import 'package:workmanager/workmanager.dart';

class BackgroundScheduler {
  static Future<void> scheduleDailyAt5PM() async {
    final now = DateTime.now();
    var scheduled = DateTime(now.year, now.month, now.day, 17, 0);
    
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(Duration(days: 1));
    }
    
    await Workmanager().registerPeriodicTask(
      "daily_5pm",
      "myTask",
      frequency: Duration(hours: 24),
      initialDelay: scheduled.difference(now),
    );
  }
}