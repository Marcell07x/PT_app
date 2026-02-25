import 'package:workmanager/workmanager.dart';

//implemented at the end of the questionaire
//it doesn't set the time yet
class BackgroundScheduler {
    static Future<void> scheduleDailyAt5PM() async {
        final now = DateTime.now();
        var scheduled = DateTime(now.year, now.month, now.day, 18, 0);
        if (scheduled.isBefore(now)) scheduled = scheduled.add(Duration(days: 1));
        await Workmanager().registerPeriodicTask(
            "task_5pm",
            "test_noti",
            frequency: Duration(hours: 24),
        );
    }
}