import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'workoutsthisweek.dart';

//goal: to make a variable, that is set true the secound day after 
//it was set to false, and to do it a maximum amount of 3 times a week
class WorkoutSignal {
    static Future<void> _saveTodayAsDays() async {
        final prefs = await SharedPreferences.getInstance();

        DateTime now1 = DateTime.now();
        DateTime date1 = DateTime(now1.year, now1.month, now1.day);
        DateTime date2 = DateTime(2020, 01, 01);
        int todayInNum = date1.difference(date2).inDays;

        await prefs.setInt("lastWorkoutDate", todayInNum);
    }

    static VoidCallback? _onSignalChanged;
    static set onSignalChanged(VoidCallback? callback) {
        _onSignalChanged = callback;
    }

    static Future<void> setSignalFalse() async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("signal", false);
        await _saveTodayAsDays();

        _onSignalChanged?.call();
    }

    //for debug/developement purposes
    static Future<void> debugSetSignalTrue() async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("signal", true);

        _onSignalChanged?.call();
    }

    static Future<void> setSignalTrueA() async {
        final prefs = await SharedPreferences.getInstance();
        int levelA = prefs.getInt('level') ?? 1; // this ?? 1; might be a temporary solution

        if (levelA < 150) {
            DateTime now1 = DateTime.now();
            DateTime date1 = DateTime(now1.year, now1.month, now1.day);
            DateTime date2 = DateTime(2020, 01, 01);
            int todayInNum = date1.difference(date2).inDays;
            int lastWorkoutDate = prefs.getInt("lastWorkoutDate") ?? todayInNum;

            if (todayInNum != lastWorkoutDate) {
                await prefs.setBool("signal", true);
            }
        }
    }

    static Future<void> setSignalTrueB() async {
        final prefs = await SharedPreferences.getInstance();
        int workoutCount = prefs.getInt('workoutsThisWeek') ?? 0;
        int levelA = prefs.getInt('level') ?? 1;

        await WorkoutsThisWeek.checkAndResetWeek();

        if (levelA > 149 && workoutCount < 3) { 
            DateTime now1 = DateTime.now();
            DateTime date1 = DateTime(now1.year, now1.month, now1.day);
            DateTime date2 = DateTime(2020, 01, 01);
            int todayInNum = date1.difference(date2).inDays;
            int lastWorkoutDate = prefs.getInt("lastWorkoutDate") ?? todayInNum;

            if (todayInNum > lastWorkoutDate + 1) {
                await prefs.setBool("signal", true);
            }
        }
    }

    static Future<void> setSignalTrue() async {
        await setSignalTrueA();
        await setSignalTrueB();
    }
}