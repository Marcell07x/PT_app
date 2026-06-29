import 'package:shared_preferences/shared_preferences.dart';

class WorkoutsThisWeek {
    static Future<void> checkAndResetWeek() async {
        final prefs = await SharedPreferences.getInstance();
        final now = DateTime.now();

        final currentWeekStart = DateTime(now.year, now.month, now.day - (now.weekday - 1));

        final lastWeekStartStr = prefs.getString('lastWeekStart');

        if (lastWeekStartStr == null) {
            await prefs.setString('lastWeekStart', currentWeekStart.toIso8601String());
        } else {
            final lastWeekStart = DateTime.parse(lastWeekStartStr);
            
            if (currentWeekStart != lastWeekStart) {
                await prefs.setInt('workoutsThisWeek', 0);
                await prefs.setString('lastWeekStart', currentWeekStart.toIso8601String());
            }
        }
    }
}