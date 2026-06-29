import 'package:flutter/material.dart';
import 'package:getshap/core/workout_signal.dart';
import 'package:getshap/notifications/schedule_noti.dart';
import 'package:getshap/dev/manuallysetlevel.dart';
import 'package:getshap/onboarding/question_gender.dart';
import 'package:getshap/onboarding/questionaire.dart';

class DebugButtonsLogic {
    static Future<void> handleSetLevelPressed({
        required BuildContext context,
        required VoidCallback updateState,
        required void Function(int) setWorkoutDone,
    }) async {
        Navigator.of(context).pop();
        setWorkoutDone(0);
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

    static void handleFormPressed(BuildContext context) {
        Navigator.of(context).pop();
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => QuestionGenderPage(data: QuestionnaireData()),
            ),
        );
    }
}
