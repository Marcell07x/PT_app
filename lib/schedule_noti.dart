import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'l10n/app_localizations.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

//the time zone is set to Budapest

class ScheduleNotifications {
    static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    static Future<void> initNotification() async {
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
        tz.initializeTimeZones();

        await _checkExactAlarmPermission();
    }

    static Future<bool> _checkExactAlarmPermission() async {
        if (await Permission.scheduleExactAlarm.isGranted) {
            return true;
        } else {
            final status = await Permission.scheduleExactAlarm.request();
            return status.isGranted;
        }
    }

    static Future<void> testNoti() async {
        await flutterLocalNotificationsPlugin.zonedSchedule(
            id: 0,
            title: 'Successful message',
            body: 'testing daily notifications',
            scheduledDate: _nextInstanceOfTime(20),
            notificationDetails: const NotificationDetails(
                android: AndroidNotificationDetails(
                    'daily notification channel id',
                    'daily notification channel name',
                    channelDescription: 'daily notification description',
                ),
            ),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time,
        );
    }

    //it's not needed
    static tz.TZDateTime _nextInstanceOfTime(int time) {
        final location = tz.getLocation('Europe/Budapest');
        final tz.TZDateTime now = tz.TZDateTime.now(location);  

        tz.TZDateTime scheduledDate = tz.TZDateTime(
            location,
            now.year,
            now.month,
            now.day,
            time,
        );
        if (scheduledDate.isBefore(now)) {
            scheduledDate = scheduledDate.add(const Duration(days: 1));
        }
        return scheduledDate;
    }

    static Future<void> dayLaterNoti(BuildContext context) async {
        final location = tz.getLocation('Europe/Budapest');
        final tz.TZDateTime now = tz.TZDateTime.now(location);
        
        tz.TZDateTime dayLaterTime = now.add(const Duration(hours: 24));
        tz.TZDateTime testTime = now.add(const Duration(seconds: 60));

        if (dayLaterTime.hour >= 21) {
            dayLaterTime = tz.TZDateTime(location, now.year, now.month, now.day + 1, 21);
        } else if (dayLaterTime.hour <= 6) {
            dayLaterTime = tz.TZDateTime(location, now.year, now.month, now.day + 1, 6);
        }

        final String reminderTitle = AppLocalizations.of(context)!.workoutReminderTitle;
        final String reminderBody = AppLocalizations.of(context)!.workoutReminderBody;

        await flutterLocalNotificationsPlugin.zonedSchedule(
            id: 0,
            title: reminderTitle,
            body: reminderBody,
            scheduledDate: testTime,
            notificationDetails: const NotificationDetails(
                android: AndroidNotificationDetails(
                    'Workout reminder id',
                    'Workout reminder notifications',
                    channelDescription: 'Reminds users to work out',
                ),
            ),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time,
        );
    }

    static Future<void> testImmediateNotification() async {
    // AZONNALI megjelenítésre való a show(), nem a zonedSchedule
        await flutterLocalNotificationsPlugin.show(
        id: 999,
        title: 'Teszt értesítés',
        body: 'Ez egy teszt',
        notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
                'channel_id',
                'channel_name',
                importance: Importance.high,
            ),
        ),
    );
}

}