import 'package:workmanager/workmanager.dart';

//implemented at the end of the questionaire
class BackgroundScheduler {
    static Future<void> scheduleDailyAt5PM() async {
        final now = DateTime.now();
        var scheduled = DateTime(now.year, now.month, now.day, 17, 0);
        if (scheduled.isBefore(now)) scheduled = scheduled.add(Duration(days: 1));
        await Workmanager().registerPeriodicTask(
            "task_5pm",
            "backgroundTask",
            frequency: Duration(hours: 24),
            initialDelay: scheduled.difference(now),
        );
    }
}