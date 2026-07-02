import 'package:shared_preferences/shared_preferences.dart';
import 'package:getshap/core/streak/streak_date_utils.dart';
import 'package:getshap/core/streak/streak_state.dart';

//goal: workout streak with a single storable streak freeze
//
//      every finished workout increases the streak by 1 (max once a day),
//      a penalty (_fail) uses up the freeze if there is one, otherwise
//      the streak resets to 0
//
//      phase A (level < 150): one workout is expected every day, every
//      missed day is a penalty
//
//      phase B (level >= 150): 3 workouts are expected per week (Mon-Sun,
//      a workout only fits every second day). A penalty hits as soon as
//      the weekly goal becomes unreachable, and the goal is lowered to
//      what is still doable. At the week rollover the (possibly lowered)
//      goal is checked one more time.
//
//      freeze recharge: two consecutive weeks with at least 4 (phase A)
//      or 3 (phase B) workouts refill the empty freeze slot - this only
//      looks at the weekly workout counts, not at the streak
//
//      the days since the last check are replayed one by one, so the
//      result is the same as if the app had been opened every day
class StreakManager {
    static const int _phaseBLevel = 150;
    static const int _weeklyTarget = 3;

    //call on app start / home screen refresh: handles missed workouts
    //(now is only meant to be overridden by tests)
    static Future<void> checkStreak({DateTime? now}) async {
        final prefs = await SharedPreferences.getInstance();
        final state = _loadAndProcess(prefs, now ?? DateTime.now());
        await state.save(prefs);
    }

    //call when a workout is finished: credits today to the streak
    static Future<void> onWorkoutCompleted({DateTime? now}) async {
        final prefs = await SharedPreferences.getInstance();
        final DateTime current = now ?? DateTime.now();
        final state = _loadAndProcess(prefs, current);

        int today = StreakDateUtils.dayNum(current);
        if (state.lastStreakDate != today) {
            state.streak++;
            state.weekCount++;
            state.lastStreakDate = today;
            if (state.streak == 1) {
                state.startDate = today;
            }
        }

        await state.save(prefs);
    }

    static StreakState _loadAndProcess(SharedPreferences prefs, DateTime now) {
        int today = StreakDateUtils.dayNum(now);
        int currentWeekStart = StreakDateUtils.weekStartNum(now);
        int level = prefs.getInt('level') ?? 1;

        final state = StreakState.load(prefs, today, currentWeekStart);

        for (int d = state.lastProcessed + 1; d <= today; d++) {
            //d is the first day of a new week: close the finished week
            if (d - state.weekStart >= 7) {
                _rollWeek(state, level, d);
            }

            if (level < _phaseBLevel) {
                //phase A: the day before d is over, it had to be covered
                //by a workout or by the freeze
                if (state.streak > 0 && state.lastStreakDate < d - 1) {
                    bool hadFreeze = state.freeze == 1;
                    _fail(state, d - 1);
                    if (hadFreeze) {
                        state.lastStreakDate = d - 1;
                    }
                }
            } else {
                //phase B: penalty as soon as the weekly goal cannot be
                //reached anymore, then the goal drops to what still fits
                int lastDayOfWeek = state.weekStart + 6;
                int maxRemaining = (lastDayOfWeek - d + 2) ~/ 2;
                if (state.weekCount + maxRemaining < state.weekReq) {
                    if (state.streak > 0) {
                        _fail(state, d);
                    }
                    state.weekReq = state.weekCount + maxRemaining;
                }
            }
        }

        if (today > state.lastProcessed) {
            state.lastProcessed = today;
        }
        return state;
    }

    //closes the week that ended right before newWeekStart
    static void _rollWeek(StreakState state, int level, int newWeekStart) {
        //freeze recharge: two consecutive weeks reaching the recharge
        //target refill the empty freeze slot
        int rechargeNeed = level < _phaseBLevel ? 4 : _weeklyTarget;
        if (state.weekCount >= rechargeNeed) {
            state.qualWeeks++;
        } else {
            state.qualWeeks = 0;
        }
        if (state.qualWeeks >= 2) {
            if (state.freeze == 0) {
                state.freeze = 1;
            }
            state.qualWeeks = 0;
        }

        //phase B: the closed week had to reach its (possibly lowered) goal
        if (level >= _phaseBLevel && state.streak > 0 && state.weekCount < state.weekReq) {
            _fail(state, newWeekStart - 1);
        }

        state.weekCount = 0;
        state.weekReq = _weeklyTarget;
        state.weekStart = newWeekStart;
    }

    //one penalty: the freeze absorbs it, otherwise the streak resets
    static void _fail(StreakState state, int failDay) {
        if (state.freeze == 1) {
            state.freeze = 0;
            state.freezeDays.add(failDay);
        } else {
            state.streak = 0;
            state.startDate = 0;
            state.freezeDays.clear();
        }
    }
}
