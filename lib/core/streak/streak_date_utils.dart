//goal: small date helpers for the streak system
//      days are stored as "number of days since 2020-01-01" (like lastWorkoutDate),
//      but computed through UTC so daylight saving changes cannot shift the result
class StreakDateUtils {
    //day number of a calendar date
    static int dayNum(DateTime d) {
        return DateTime.utc(d.year, d.month, d.day).difference(DateTime.utc(2020, 1, 1)).inDays;
    }

    //day number of the Monday of the week the date falls in
    static int weekStartNum(DateTime d) {
        return dayNum(d) - (d.weekday - 1);
    }

    //calendar date of a day number (only year/month/day are meaningful)
    static DateTime dateFromDayNum(int dayNum) {
        return DateTime.utc(2020, 1, 1).add(Duration(days: dayNum));
    }
}
