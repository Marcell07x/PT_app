import 'package:shared_preferences/shared_preferences.dart';
import 'package:getshap/core/streak/streak_date_utils.dart';

//goal: every streak related SharedPreferences key in one place,
//      so StreakManager can work on plain fields
class StreakState {
    //current streak value
    int streak;
    //stored streak freeze (0 or 1, max 1 can be stored)
    int freeze;
    //last day credited with a workout (or covered by a freeze in phase A)
    int lastStreakDate;
    //first day of the current streak (0 = no active streak)
    int startDate;
    //days on which a freeze was used up (belongs to the current streak)
    List<int> freezeDays;
    //Monday of the week the processing is currently in
    int weekStart;
    //workouts done in that week
    int weekCount;
    //workouts required from that week (3 in phase B, lowered after a fail)
    int weekReq;
    //consecutive weeks that qualified for the freeze recharge
    int qualWeeks;
    //last day the day-by-day processing has handled
    int lastProcessed;

    StreakState({
        required this.streak,
        required this.freeze,
        required this.lastStreakDate,
        required this.startDate,
        required this.freezeDays,
        required this.weekStart,
        required this.weekCount,
        required this.weekReq,
        required this.qualWeeks,
        required this.lastProcessed,
    });

    static StreakState load(SharedPreferences prefs, int today, int currentWeekStart) {
        //first run: adopt the existing weekly counter if it is from this week,
        //so an update mid-week does not look like missed workouts
        int firstRunWeekCount = 0;
        final lastWeekStartStr = prefs.getString('lastWeekStart');
        if (lastWeekStartStr != null) {
            final lastWeekStart = DateTime.parse(lastWeekStartStr);
            if (StreakDateUtils.weekStartNum(lastWeekStart) == currentWeekStart) {
                firstRunWeekCount = prefs.getInt('workoutsThisWeek') ?? 0;
            }
        }

        return StreakState(
            streak: prefs.getInt('streak') ?? 0,
            freeze: prefs.getInt('streakFreeze') ?? 0,
            //defaults to yesterday, so the very first workout can be credited
            lastStreakDate: prefs.getInt('lastStreakDate') ?? prefs.getInt('lastWorkoutDate') ?? (today - 1),
            startDate: prefs.getInt('streakStartDate') ?? 0,
            freezeDays: (prefs.getStringList('streakFreezeDays') ?? []).map(int.parse).toList(),
            weekStart: prefs.getInt('streakWeekStart') ?? currentWeekStart,
            weekCount: prefs.getInt('streakWorkoutsWeek') ?? firstRunWeekCount,
            weekReq: prefs.getInt('streakWeekReq') ?? 3,
            qualWeeks: prefs.getInt('streakQualWeeks') ?? 0,
            lastProcessed: prefs.getInt('streakLastProcessed') ?? today,
        );
    }

    Future<void> save(SharedPreferences prefs) async {
        await prefs.setInt('streak', streak);
        await prefs.setInt('streakFreeze', freeze);
        await prefs.setInt('lastStreakDate', lastStreakDate);
        await prefs.setInt('streakStartDate', startDate);
        await prefs.setStringList('streakFreezeDays', freezeDays.map((d) => d.toString()).toList());
        await prefs.setInt('streakWeekStart', weekStart);
        await prefs.setInt('streakWorkoutsWeek', weekCount);
        await prefs.setInt('streakWeekReq', weekReq);
        await prefs.setInt('streakQualWeeks', qualWeeks);
        await prefs.setInt('streakLastProcessed', lastProcessed);
    }
}
