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
//      looks at the weekly workout counts, not at the streak. The grant
//      happens right at the workout that completes the second week, so
//      the freeze is visible the moment it is earned
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
            state.workoutDays.add(today);
            if (state.streak == 1) {
                state.startDate = today;
            }

            //freeze recharge right when it is earned: this workout made the
            //week reach the target and the previous week qualified too
            int level = prefs.getInt('level') ?? 1;
            if (state.weekCount >= _rechargeNeed(level) &&
                state.qualWeeks >= 1 &&
                state.freeze == 0 &&
                state.grantedWeekStart != state.weekStart) {
                state.freeze = 1;
                state.grantedWeekStart = state.weekStart;
            }
        }

        await state.save(prefs);
    }

    static StreakState _loadAndProcess(SharedPreferences prefs, DateTime now) {
        int today = StreakDateUtils.dayNum(now);
        int currentWeekStart = StreakDateUtils.weekStartNum(now);
        int level = prefs.getInt('level') ?? 1;

        final state = StreakState.load(prefs, today, currentWeekStart);

        //the first day the weekly rule can apply: everything up to
        //lastProcessed already ran under the daily rules
        if (level >= _phaseBLevel && state.phaseBSince == 0) {
            state.phaseBSince = state.lastProcessed + 1;
        }

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
            } else if (_fullPhaseBWeek(state)) {
                //phase B: penalty as soon as the weekly goal cannot be
                //reached anymore, then the goal drops to what still fits
                int lastDayOfWeek = state.weekStart + 6;
                int maxRemaining = (lastDayOfWeek - d + 2) ~/ 2;
                if (state.weekCount + maxRemaining < state.weekReq) {
                    if (state.streak > 0) {
                        //the snowflake goes on d - 1: the last day a workout
                        //could still have kept the goal reachable (d itself
                        //may still get a workout towards the lowered goal)
                        _fail(state, d - 1);
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

    //weekly workout count needed for the freeze recharge
    static int _rechargeNeed(int level) {
        return level < _phaseBLevel ? 4 : _weeklyTarget;
    }

    //true if the week held in weekStart was already fully inside phase B.
    //The transition week is part phase A, so its 3-workout goal could be
    //impossible to reach (phase A days can block phase B workouts).
    static bool _fullPhaseBWeek(StreakState state) {
        return state.phaseBSince > 0 && state.weekStart >= state.phaseBSince;
    }

    //closes the week that ended right before newWeekStart
    static void _rollWeek(StreakState state, int level, int newWeekStart) {
        //freeze recharge: two consecutive weeks reaching the recharge
        //target refill the empty freeze slot
        if (state.weekCount >= _rechargeNeed(level)) {
            if (state.grantedWeekStart == state.weekStart) {
                //the grant of this pair already happened after a workout
                state.qualWeeks = 0;
            } else {
                state.qualWeeks++;
            }
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
        if (level >= _phaseBLevel &&
            _fullPhaseBWeek(state) &&
            state.streak > 0 &&
            state.weekCount < state.weekReq) {
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
            state.workoutDays.clear();
        }
    }
}
