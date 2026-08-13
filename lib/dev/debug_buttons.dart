import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getshap/core/workout_signal.dart';
import 'package:getshap/core/debug_clock.dart';
import 'package:getshap/core/streak/streak_manager.dart';
import 'package:getshap/core/streak/streak_date_utils.dart';
import 'package:getshap/notifications/schedule_noti.dart';
import 'package:getshap/dev/manuallysetlevel.dart';
import 'package:getshap/onboarding/question_gender.dart';
import 'package:getshap/onboarding/questionaire.dart';

class DebugButtonsLogic {
    static Future<void> handleSetLevelPressed({
        required BuildContext context,
        required VoidCallback updateState,
    }) async {
        Navigator.of(context).pop();
        WorkoutSignal.debugSetSignalTrue();
        await ScheduleNotifications.testNoti();
        updateState();
        int? newLevel = await ManuallySetLevel.showLevelInputDialog(context);
        if (newLevel != null) {
            await ManuallySetLevel.saveLevelToPrefs(newLevel);
            ManuallySetLevel.showSuccess(context, 'Level set: $newLevel');
            updateState();
        }
    }

    //debug: move the simulated clock forward by a few days and open a fresh
    //day (workout enabled again), exactly as if that many days had passed
    static Future<void> handleAdvanceDayPressed({
        required BuildContext context,
        required Future<void> Function() refresh,
    }) async {
        Navigator.of(context).pop();
        int? days = await ManuallySetLevel.showDaysInputDialog(context);
        if (days == null || days <= 0) return;

        await DebugClock.advance(days);
        //a new day: today's workout can be done again
        await StreakManager.checkStreak();
        await WorkoutSignal.refreshSignal();
        await refresh();

        if (!context.mounted) return;
        final now = DebugClock.now();
        final date = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Now: $date (offset ${DebugClock.offsetDays} days)'),
                backgroundColor: Colors.green,
            ),
        );
    }

    //debug: show all raw streak values so a wrong day / weekCount is visible
    static Future<void> handleDumpStatePressed(BuildContext context) async {
        Navigator.of(context).pop();
        await StreakManager.checkStreak();
        final prefs = await SharedPreferences.getInstance();

        String daysToDates(List<String>? nums) {
            final list = (nums ?? []).map(int.parse).toList()..sort();
            if (list.isEmpty) return '[]';
            return list.map((n) {
                final d = StreakDateUtils.dateFromDayNum(n);
                return '${d.month}/${d.day}($n)';
            }).join(', ');
        }

        int today = StreakDateUtils.dayNum(DebugClock.now());
        final lines = <String>[
            'today=$today  offset=${DebugClock.offsetDays}',
            'level=${prefs.getInt('level')}  incspeed=${prefs.getInt('incspeed')}  signal=${prefs.getBool('signal')}',
            'streak=${prefs.getInt('streak')}  freeze=${prefs.getInt('streakFreeze')}',
            'startDate=${prefs.getInt('streakStartDate')}',
            'lastStreakDate=${prefs.getInt('lastStreakDate')}',
            'lastProcessed=${prefs.getInt('streakLastProcessed')}',
            'weekStart=${prefs.getInt('streakWeekStart')}',
            'weekCount=${prefs.getInt('streakWorkoutsWeek')}',
            'weekReq=${prefs.getInt('streakWeekReq')}',
            'qualWeeks=${prefs.getInt('streakQualWeeks')}',
            'grantedWeek=${prefs.getInt('streakGrantedWeek')}',
            'phaseBSince=${prefs.getInt('streakPhaseBSince')}',
            'workoutsThisWeek=${prefs.getInt('workoutsThisWeek')}',
            'lastWorkout=${prefs.getInt('lastWorkoutDate')}  bonusWeek=${prefs.getInt('bonusWeek')}',
            'workoutDays=${daysToDates(prefs.getStringList('streakWorkoutDays'))}',
            'freezeDays=${daysToDates(prefs.getStringList('streakFreezeDays'))}',
        ];

        if (!context.mounted) return;
        await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
                title: const Text('State'),
                content: SingleChildScrollView(
                    child: SelectableText(lines.join('\n'), style: const TextStyle(fontSize: 13)),
                ),
                actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                    ),
                ],
            ),
        );
    }

    static void handleFormPressed(BuildContext context) {
        Navigator.of(context).pop();
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => QuestionGenderPage(data: QuestionnaireData()),
            ),
        );
    }
}
