import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:getshap/core/debug_clock.dart';
import 'package:getshap/workout/workoutsthisweek.dart';

// Single source of truth for "when can the user next work out".
//
// From this one computation (nextWorkoutDayIndex) we derive:
//   - signal        : whether today is a workout day (button routing / streak flame)
//   - daysUntilNext : the number shown on the countdown page
//
// Rules:
//   - Beginner (level < 150): can train again the next day, no weekly cap.
//   - Advanced (level >= 150): at most 3 workouts per week (Mon-Sun, resets on
//     Monday) with at least 1 rest day between two workouts.
//   - Transition week (the week the user reaches level 150): if the level-up
//     workout was the >=3rd of the week and happened on/before Thursday, one
//     extra workout is allowed that week, 1 rest day later (overrides the cap).
class WorkoutSignal {
    static const int phaseBLevel = 150;

    // Days since 2020-01-01 for "today" (same epoch as lastWorkoutDate).
    static int _todayIndex() {
        final now = DebugClock.now();
        final today = DateTime(now.year, now.month, now.day);
        return today.difference(DateTime(2020, 01, 01)).inDays;
    }

    // Days-since-2020 index of this week's Monday.
    static int _weekStartIndex() {
        final now = DebugClock.now();
        final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
        return monday.difference(DateTime(2020, 01, 01)).inDays;
    }

    static VoidCallback? _onSignalChanged;
    static set onSignalChanged(VoidCallback? callback) {
        _onSignalChanged = callback;
    }

    // The earliest day index on which the user may train next.
    static Future<int> nextWorkoutDayIndex() async {
        final prefs = await SharedPreferences.getInstance();
        await WorkoutsThisWeek.checkAndResetWeek();

        final today = _todayIndex();
        // never worked out yet (fresh onboarding, lastWorkoutDate unset) -> the
        // user can train today
        final lastStored = prefs.getInt('lastWorkoutDate');
        if (lastStored == null) {
            return today;
        }
        final last = lastStored;
        final level = prefs.getInt('level') ?? 1;
        final count = prefs.getInt('workoutsThisWeek') ?? 0;
        final weekStart = _weekStartIndex();
        final nextMonday = weekStart + 7;

        // Beginner: next day, no weekly cap.
        if (level < phaseBLevel) {
            return last + 1;
        }

        // Transition-week bonus: one extra workout, 1 rest day after the
        // level-up workout, ignoring the weekly cap.
        final bonusWeek = prefs.getInt('bonusWeek');
        if (bonusWeek != null && bonusWeek == weekStart) {
            return last + 2;
        }

        // Advanced: 1 rest day between workouts, max 3 per week.
        if (count < 3) {
            return last + 2;
        }
        // This week is full -> wait for the Monday reset (still >= 1 rest day).
        final nextDay = last + 2;
        return nextDay > nextMonday ? nextDay : nextMonday;
    }

    // How many whole days until the next possible workout (rounded up, never
    // negative). 0 means the user can train today.
    static Future<int> daysUntilNextWorkout() async {
        final diff = await nextWorkoutDayIndex() - _todayIndex();
        return diff > 0 ? diff : 0;
    }

    static Future<bool> canWorkoutToday() async {
        return _todayIndex() >= await nextWorkoutDayIndex();
    }

    // Recompute the cached `signal` flag from the current state and notify the
    // home screen. Called at app start and after the debug clock advances.
    static Future<void> refreshSignal() async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('signal', await canWorkoutToday());
        _onSignalChanged?.call();
    }

    // Debug/development: force today into a workout day.
    static Future<void> debugSetSignalTrue() async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('signal', true);
        _onSignalChanged?.call();
    }

    // Called when a workout is completed. Records the workout, maintains the
    // transition-week bonus token, and marks today as no longer a workout day.
    // [levelBefore] / [levelAfter] are the user's level before and after the
    // level-up this workout triggered.
    static Future<void> onWorkoutFinished(int levelBefore, int levelAfter) async {
        final prefs = await SharedPreferences.getInstance();
        await WorkoutsThisWeek.checkAndResetWeek();

        final today = _todayIndex();
        final weekStart = _weekStartIndex();
        final thursday = weekStart + 3;
        // workoutsThisWeek has already been incremented for this workout.
        final count = prefs.getInt('workoutsThisWeek') ?? 0;
        final bonusWeek = prefs.getInt('bonusWeek');

        if (levelBefore < phaseBLevel &&
            levelAfter >= phaseBLevel &&
            count >= 3 &&
            today <= thursday) {
            // Crossed into 150+ as the >=3rd workout of the week, on/before
            // Thursday -> one more spaced workout still fits before the week
            // ends, so grant the bonus token.
            await prefs.setInt('bonusWeek', weekStart);
        } else if (levelBefore >= phaseBLevel && bonusWeek == weekStart) {
            // The single advanced workout after the transition -> consume it.
            await prefs.remove('bonusWeek');
        }

        await prefs.setInt('lastWorkoutDate', today);
        await prefs.setBool('signal', false);
        _onSignalChanged?.call();
    }
}
