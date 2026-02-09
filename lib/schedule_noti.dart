import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ScheduleNotifications {
    static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    static bool _isInitialized = false;

    static bool get isInitialized => _isInitialized;

    static Future<void> initNotification() async {
        if (_isInitialized) return;

        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');
        
        final DarwinInitializationSettings initializationSettingsDarwin =
            DarwinInitializationSettings(
                requestAlertPermission: true,
                requestBadgePermission: true,
                requestSoundPermission: true,
            );
        
        final InitializationSettings initSettings = InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            macOS: initializationSettingsDarwin,
        );
        
        await flutterLocalNotificationsPlugin.initialize(
            initSettings,
        );
        _isInitialized = true;
    }

    static Future<void> testNoti() async {
        await initNotification();
        
        const AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails('your channel id', 'your channel name',
                channelDescription: 'your channel description',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker');
        const NotificationDetails notificationDetails =
            NotificationDetails(android: androidNotificationDetails);
        await flutterLocalNotificationsPlugin.show(
            0,
            'plain title',
            'plain body',
            notificationDetails,
        );
    }

    static Future<void> noti5PM() async {
        final prefs = await SharedPreferences.getInstance();
        bool? signal = prefs.getBool('signal');

        if (signal == true) {
        }
    }

    static Future<void> noti8PM() async {
        final prefs = await SharedPreferences.getInstance();
        bool? signal = prefs.getBool('signal');
    }
}