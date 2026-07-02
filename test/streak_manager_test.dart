import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getshap/core/streak/streak_manager.dart';
import 'package:getshap/core/streak/streak_date_utils.dart';

//2024-01-01 was a Monday, day(0) = Monday of week 1
DateTime day(int i) => DateTime(2024, 1, 1 + i);

Future<SharedPreferences> setup(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    return SharedPreferences.getInstance();
}

void main() {
    TestWidgetsFlutterBinding.ensureInitialized();

    test('day numbers are continuous across months', () {
        expect(StreakDateUtils.dayNum(DateTime(2024, 2, 1)) - StreakDateUtils.dayNum(day(0)), 31);
        expect(StreakDateUtils.weekStartNum(day(9)), StreakDateUtils.dayNum(day(7)));
    });

    group('phase A (level < 150)', () {
        test('daily workouts build the streak, max once a day', () async {
            final prefs = await setup({'level': 100});
            await StreakManager.onWorkoutCompleted(now: day(0));
            await StreakManager.onWorkoutCompleted(now: day(0));
            await StreakManager.onWorkoutCompleted(now: day(1));
            expect(prefs.getInt('streak'), 2);
            expect(prefs.getInt('streakStartDate'), StreakDateUtils.dayNum(day(0)));
        });

        test('one missed day without freeze resets the streak', () async {
            final prefs = await setup({'level': 100});
            await StreakManager.onWorkoutCompleted(now: day(0));
            await StreakManager.onWorkoutCompleted(now: day(1));
            //day(2) is skipped
            await StreakManager.checkStreak(now: day(3));
            expect(prefs.getInt('streak'), 0);
            expect(prefs.getInt('streakStartDate'), 0);
        });

        test('one missed day with freeze keeps the streak', () async {
            final prefs = await setup({'level': 100, 'streakFreeze': 1});
            await StreakManager.onWorkoutCompleted(now: day(0));
            await StreakManager.onWorkoutCompleted(now: day(1));
            //day(2) is skipped
            await StreakManager.onWorkoutCompleted(now: day(3));
            expect(prefs.getInt('streak'), 3);
            expect(prefs.getInt('streakFreeze'), 0);
            expect(prefs.getStringList('streakFreezeDays'),
                [StreakDateUtils.dayNum(day(2)).toString()]);
        });

        test('two missed days use the freeze and reset the streak', () async {
            final prefs = await setup({'level': 100, 'streakFreeze': 1});
            await StreakManager.onWorkoutCompleted(now: day(0));
            //day(1) and day(2) are skipped
            await StreakManager.checkStreak(now: day(3));
            expect(prefs.getInt('streak'), 0);
            expect(prefs.getInt('streakFreeze'), 0);
            expect(prefs.getStringList('streakFreezeDays'), isEmpty);
        });

        test('two weeks with 4+ workouts recharge the freeze, even if the streak died', () async {
            final prefs = await setup({'level': 100});
            //week 1: Mon-Thu, Friday is missed -> streak resets on Saturday
            for (int i = 0; i <= 3; i++) {
                await StreakManager.onWorkoutCompleted(now: day(i));
            }
            await StreakManager.checkStreak(now: day(5));
            expect(prefs.getInt('streak'), 0);
            //week 2: Mon-Thu again
            for (int i = 7; i <= 10; i++) {
                await StreakManager.onWorkoutCompleted(now: day(i));
            }
            //Monday of week 3: both weeks had 4 workouts
            await StreakManager.checkStreak(now: day(14));
            expect(prefs.getInt('streakFreeze'), 1);
            expect(prefs.getInt('streakQualWeeks'), 0);
        });

        test('a week under 4 workouts breaks the recharge chain', () async {
            final prefs = await setup({'level': 100});
            for (int i = 0; i <= 3; i++) {
                await StreakManager.onWorkoutCompleted(now: day(i));
            }
            //week 2: only 3 workouts
            for (int i = 7; i <= 9; i++) {
                await StreakManager.onWorkoutCompleted(now: day(i));
            }
            await StreakManager.checkStreak(now: day(14));
            expect(prefs.getInt('streakFreeze'), 0);
            expect(prefs.getInt('streakQualWeeks'), 0);
        });
    });

    group('phase B (level >= 150)', () {
        test('Mon/Wed/Fri workouts survive the rollover and qualify', () async {
            final prefs = await setup({'level': 200});
            await StreakManager.onWorkoutCompleted(now: day(0));
            await StreakManager.onWorkoutCompleted(now: day(2));
            await StreakManager.onWorkoutCompleted(now: day(4));
            await StreakManager.checkStreak(now: day(7));
            expect(prefs.getInt('streak'), 3);
            expect(prefs.getInt('streakQualWeeks'), 1);
        });

        test('two qualifying weeks recharge the freeze', () async {
            final prefs = await setup({'level': 200});
            for (final i in [0, 2, 4, 7, 9, 11]) {
                await StreakManager.onWorkoutCompleted(now: day(i));
            }
            await StreakManager.checkStreak(now: day(14));
            expect(prefs.getInt('streakFreeze'), 1);
            expect(prefs.getInt('streak'), 6);
        });

        test('0 workouts by Thursday: freeze is used, 2 workouts save the week', () async {
            final prefs = await setup({'level': 200, 'streakFreeze': 1});
            await StreakManager.onWorkoutCompleted(now: day(0));
            await StreakManager.onWorkoutCompleted(now: day(2));
            await StreakManager.onWorkoutCompleted(now: day(4));
            //week 2: nothing until Thursday
            await StreakManager.checkStreak(now: day(10));
            expect(prefs.getInt('streak'), 3, reason: 'freeze saved the streak');
            expect(prefs.getInt('streakFreeze'), 0);
            expect(prefs.getInt('streakWeekReq'), 2, reason: 'goal lowered to 2');
            expect(prefs.getStringList('streakFreezeDays'),
                [StreakDateUtils.dayNum(day(10)).toString()]);
            //Thursday + Saturday reach the lowered goal
            await StreakManager.onWorkoutCompleted(now: day(10));
            await StreakManager.onWorkoutCompleted(now: day(12));
            await StreakManager.checkStreak(now: day(14));
            expect(prefs.getInt('streak'), 5, reason: 'no penalty at the rollover');
        });

        test('0 workouts by Thursday without freeze: reset, rebuilt streak survives', () async {
            final prefs = await setup({'level': 200});
            await StreakManager.onWorkoutCompleted(now: day(0));
            await StreakManager.onWorkoutCompleted(now: day(2));
            await StreakManager.onWorkoutCompleted(now: day(4));
            await StreakManager.checkStreak(now: day(10));
            expect(prefs.getInt('streak'), 0);
            //rebuilding with Thursday + Saturday
            await StreakManager.onWorkoutCompleted(now: day(10));
            await StreakManager.onWorkoutCompleted(now: day(12));
            await StreakManager.checkStreak(now: day(14));
            expect(prefs.getInt('streak'), 2, reason: 'lowered goal protects the new streak');
        });

        test('first opened on Saturday with 0 workouts: freeze used and streak reset', () async {
            final prefs = await setup({'level': 200, 'streakFreeze': 1});
            await StreakManager.onWorkoutCompleted(now: day(0));
            await StreakManager.onWorkoutCompleted(now: day(2));
            await StreakManager.onWorkoutCompleted(now: day(4));
            //week 2: app is not opened until Saturday
            await StreakManager.checkStreak(now: day(12));
            expect(prefs.getInt('streak'), 0, reason: 'Thursday took the freeze, Saturday reset');
            expect(prefs.getInt('streakFreeze'), 0);
            expect(prefs.getInt('streakWeekReq'), 1);
            //one workout is enough from Saturday on
            await StreakManager.onWorkoutCompleted(now: day(12));
            await StreakManager.checkStreak(now: day(14));
            expect(prefs.getInt('streak'), 1);
        });

        test('a 2/3 week that stayed possible until Sunday costs one freeze at rollover', () async {
            final prefs = await setup({'level': 200, 'streakFreeze': 1});
            await StreakManager.onWorkoutCompleted(now: day(0));
            await StreakManager.onWorkoutCompleted(now: day(2));
            //the 3rd workout never happens, but stays possible until Sunday
            await StreakManager.checkStreak(now: day(7));
            expect(prefs.getInt('streak'), 2, reason: 'freeze absorbed the rollover fail');
            expect(prefs.getInt('streakFreeze'), 0);
            expect(prefs.getStringList('streakFreezeDays'),
                [StreakDateUtils.dayNum(day(6)).toString()], reason: 'marked on Sunday');
        });

        test('weeks of full absence kill the streak and the recharge chain', () async {
            final prefs = await setup({'level': 200, 'streakFreeze': 1});
            await StreakManager.onWorkoutCompleted(now: day(0));
            await StreakManager.onWorkoutCompleted(now: day(2));
            await StreakManager.onWorkoutCompleted(now: day(4));
            //two full weeks of nothing
            await StreakManager.checkStreak(now: day(24));
            expect(prefs.getInt('streak'), 0);
            expect(prefs.getInt('streakFreeze'), 0);
            expect(prefs.getInt('streakQualWeeks'), 0);
        });

        test('rest days do not lower the streak', () async {
            final prefs = await setup({'level': 200});
            await StreakManager.onWorkoutCompleted(now: day(0));
            await StreakManager.checkStreak(now: day(1));
            expect(prefs.getInt('streak'), 1);
        });
    });

    group('phase change', () {
        test('a mixed week is judged by the current phase at the rollover', () async {
            //daily workouts Mon-Sun at level 149, level crosses 150 mid-week
            final prefs = await setup({'level': 149});
            for (int i = 0; i <= 6; i++) {
                await StreakManager.onWorkoutCompleted(now: day(i));
            }
            await prefs.setInt('level', 155);
            //phase B from Monday on: the closed week had 7 workouts
            await StreakManager.checkStreak(now: day(8));
            expect(prefs.getInt('streak'), 7);
            expect(prefs.getInt('streakQualWeeks'), 1);
        });
    });
}
