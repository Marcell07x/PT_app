import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/core/workout_signal.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

//the time zone is set to Budapest
//Sometimes there won't be notification, when a workout is available,
    //but it's not a big problem

class ScheduleNotifications {
    static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    static Future<void> initNotification() async {
        // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');
        final DarwinInitializationSettings initializationSettingsDarwin =
            DarwinInitializationSettings(
                requestAlertPermission: false,
                requestBadgePermission: false,
                requestSoundPermission: false,
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
    }

    static Future<void> laterNoti(BuildContext context) async {
        final location = tz.getLocation('Europe/Budapest');
        final tz.TZDateTime now = tz.TZDateTime.now(location);

        final String reminderTitle = AppLocalizations.of(context)!.workoutReminderTitle;
        final String reminderBody = AppLocalizations.of(context)!.workoutReminderBody;

        // schedule the reminder for the next possible workout day, so it never
        // fires before the user can actually train (transition week included)
        final int days = await WorkoutSignal.daysUntilNextWorkout();
        final int hoursAdded = (days > 0 ? days : 1) * 24;

        tz.TZDateTime dayLaterTime = now.add(Duration(hours: hoursAdded));

        if (dayLaterTime.hour >= 21) {
            dayLaterTime = tz.TZDateTime(location, dayLaterTime.year, dayLaterTime.month, dayLaterTime.day, 21);
        } else if (dayLaterTime.hour <= 6) {
            dayLaterTime = tz.TZDateTime(location, dayLaterTime.year, dayLaterTime.month, dayLaterTime.day, 6);
        }

        await flutterLocalNotificationsPlugin.zonedSchedule(
            id: 0,
            title: reminderTitle,
            body: reminderBody,
            scheduledDate: dayLaterTime,
            notificationDetails: const NotificationDetails(
                android: AndroidNotificationDetails(
                    'Workout reminder id',
                    'Workout reminder notifications',
                    channelDescription: 'Reminds users to work out',
                ),
            ),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
    }

    static Future<void> testNoti() async {
        const NotificationDetails platformChannelSpecifics = NotificationDetails(
            android: AndroidNotificationDetails(
                'test_channel_id',
                'test_channel_name',
                channelDescription: 'Test notifications',
                importance: Importance.max,
                priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
        );

        await flutterLocalNotificationsPlugin.show(
            id: 0,
            title: 'Test Notification',
            body: 'Description for the test',
            notificationDetails: platformChannelSpecifics,
        );
    }

}