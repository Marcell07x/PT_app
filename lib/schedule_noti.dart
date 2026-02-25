import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// the scource for the code should be the package's page
//first goal: initialize notis and a function that sends a noti


class ScheduleNotifications {

    static Future<void> initNotification() async {
                FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');
        final DarwinInitializationSettings initializationSettingsDarwin =
            DarwinInitializationSettings(
                requestAlertPermission: true,
                requestBadgePermission: true,
                requestSoundPermission: true,
            );
        final LinuxInitializationSettings initializationSettingsLinux =
            LinuxInitializationSettings(
                defaultActionName: 'Open notification');
        final WindowsInitializationSettings initializationSettingsWindows =
            WindowsInitializationSettings(
                appName: 'Flutter Local Notifications Example',
                appUserModelId: 'Com.Dexterous.FlutterLocalNotificationsExample',
                // Search online for GUID generators to make your own
                guid: 'd49b0314-ee7a-4626-bf79-97cdb8a991bb');
        final InitializationSettings initializationSettings = InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            macOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux,
            windows: initializationSettingsWindows);
        await flutterLocalNotificationsPlugin.initialize(
            settings: initializationSettings
            );
    }

    static Future<void> testNoti() async {
        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        const AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails('your channel id', 'your channel name',
                channelDescription: 'your channel description',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker');
        const NotificationDetails notificationDetails =
            NotificationDetails(android: androidNotificationDetails);
        await flutterLocalNotificationsPlugin.show(
            id: 0, 
            title: 'plain title', 
            body: 'plain body', 
            notificationDetails: notificationDetails,
            payload: 'item x');
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