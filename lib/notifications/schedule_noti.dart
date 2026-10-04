import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/core/workout_signal.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

//goal: after the onboarding a "get started" nudge one day later, and after
//      every finished workout three notifications scheduled at once:
//        - the next workout day:                 don't forget your streak
//        - one day after that:                   the "quick workout?" reminder
//        - four days after the next workout day: "don't give up"
//      every batch clears the still pending ones first, so a workout in
//      between restarts the chain from the streak reminder
//
//the reminders are scheduled in the device's own time zone
//Sometimes there won't be notification, when a workout is available,
    //but it's not a big problem

class ScheduleNotifications {
    static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    //one id holds one pending notification: scheduling on an id that already
    //has one replaces it, so the chain needs separate ids. The welcome and
    //the streak reminder share 0 (each one starts its own batch), and so did
    //the single reminder of earlier app versions
    static const int _firstId = 0;
    static const int _reminderId = 1;
    static const int _dontGiveUpId = 2;
    static const int _testId = 99;

    static Future<void> initNotification() async {
        //the time zone database first: it is pure Dart, and scheduling needs
        //it even if the plugin init below fails
        tz.initializeTimeZones();
        //a failing init must not stop main() from starting the app
        try {
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
        } catch (e) {
            debugPrint('notification init failed: $e');
        }
    }

    static Future<bool> isNotificationGranted() async {
        if (Platform.isAndroid) {
            final androidPlugin = flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>();

            if (androidPlugin == null) return false;

            final bool? granted = await androidPlugin.areNotificationsEnabled();
            return granted == true;
        }

        else if (Platform.isIOS) {
            final status = await Permission.notification.status;
            return status == PermissionStatus.granted;
        }

        return false;
    }

    //the device's own time zone, so the reminder lands in the user's daytime
    //wherever they live; falls back to Budapest if the platform reports a
    //zone the timezone database does not know
    static Future<tz.Location> _localLocation() async {
        try {
            final TimezoneInfo info = await FlutterTimezone.getLocalTimezone();
            return tz.getLocation(info.identifier);
        } catch (e) {
            debugPrint('local time zone lookup failed: $e');
            return tz.getLocation('Europe/Budapest');
        }
    }

    //every notification goes out on this one Android channel, the one the
    //old reminder used, so existing installs don't get a second channel.
    //A channel only groups the user's settings (sound, importance, mute),
    //it never replaces a notification: that is done by cancelPending
    static NotificationDetails _details(String title, String body) {
        return NotificationDetails(
            android: AndroidNotificationDetails(
                'Workout reminder id',
                'Workout reminder notifications',
                channelDescription: 'Reminds users to work out',
                //a long text can be expanded instead of being cut off; the
                //expanded view gets the title explicitly (without a title it
                //showed "null" there)
                styleInformation: BigTextStyleInformation(body, contentTitle: title),
            ),
        );
    }

    //[days] calendar days later at the same clock time. Not days * 24 hours:
    //a DST change day is 23 or 25 hours long, which would move the clock
    //time by an hour (and out of the daytime window at 21:00)
    static tz.TZDateTime _daysAfter(tz.TZDateTime t, int days) {
        return tz.TZDateTime(t.location, t.year, t.month, t.day + days, t.hour, t.minute);
    }

    //keeps a notification inside the user's daytime (06:00 - 21:00)
    static tz.TZDateTime _daytime(tz.TZDateTime t) {
        if (t.hour >= 21) {
            return tz.TZDateTime(t.location, t.year, t.month, t.day, 21);
        } else if (t.hour <= 6) {
            return tz.TZDateTime(t.location, t.year, t.month, t.day, 6);
        }
        return t;
    }

    //when the welcome nudge goes out: one day after the onboarding
    @visibleForTesting
    static tz.TZDateTime welcomeTime(tz.TZDateTime now) {
        return _daytime(_daysAfter(now, 1));
    }

    //when the after-workout notifications go out: the streak reminder on the
    //next possible workout day, so it never fires before the user can
    //actually train (transition week included), the reminder one day after
    //it and the "don't give up" message four days after it
    @visibleForTesting
    static List<tz.TZDateTime> afterWorkoutTimes(tz.TZDateTime now, int daysUntilNext) {
        final tz.TZDateTime streak =
            _daytime(_daysAfter(now, daysUntilNext > 0 ? daysUntilNext : 1));
        return [
            streak,
            _daysAfter(streak, 1),
            _daysAfter(streak, 4),
        ];
    }

    //clears every notification that is still waiting to be shown (the ones
    //already shown stay). Needs no permission, so it also runs when the
    //notifications are off
    static Future<void> cancelPending() async {
        try {
            await flutterLocalNotificationsPlugin.cancelAllPendingNotifications();
        } catch (e) {
            debugPrint('cancelPending failed: $e');
        }
    }

    //one notification in its own try/catch, so a failing one does not stop
    //the rest of its batch. The title is required: a notification without
    //one showed "null" in its expanded view
    static Future<void> _schedule({
        required int id,
        required String title,
        required String body,
        required tz.TZDateTime when,
    }) async {
        try {
            await flutterLocalNotificationsPlugin.zonedSchedule(
                id: id,
                title: title,
                body: body,
                scheduledDate: when,
                notificationDetails: _details(title, body),
                androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            );
        } catch (e) {
            debugPrint('scheduling notification $id failed: $e');
        }
    }

    //the first trip to the home screen after the notification prompt. Only
    //schedules: the caller clears the pending ones first. A workout before it
    //fires replaces it with the after-workout notifications
    static Future<void> welcomeNoti(BuildContext context) async {
        try {
            //looked up before the first await: the screen may be gone after it
            final AppLocalizations loc = AppLocalizations.of(context)!;

            //iOS refuses to schedule without notification permission (it
            //throws), so skip the nudge when notifications are off
            if (!await isNotificationGranted()) return;

            final location = await _localLocation();
            await _schedule(
                id: _firstId,
                title: loc.welcomeNotiTitle,
                body: loc.welcomeNotiBody,
                when: welcomeTime(tz.TZDateTime.now(location)),
            );
        } catch (e) {
            debugPrint('welcomeNoti failed: $e');
        }
    }

    //called by _finishWorkout: the three after-workout notifications at
    //once. The second and third only show up if the user does not train in
    //between, because the next finished workout clears them and starts over
    static Future<void> laterNoti(BuildContext context) async {
        try {
            //looked up before the first await: the screen may be gone after it
            final AppLocalizations loc = AppLocalizations.of(context)!;

            //before the permission check: with notifications off, an older
            //chain must not stay pending and show up once they are back on
            await cancelPending();

            //iOS refuses to schedule without notification permission (it
            //throws), so skip the reminders when notifications are off
            if (!await isNotificationGranted()) return;

            final location = await _localLocation();
            final int days = await WorkoutSignal.daysUntilNextWorkout();
            final List<tz.TZDateTime> times =
                afterWorkoutTimes(tz.TZDateTime.now(location), days);

            await _schedule(
                id: _firstId,
                title: loc.streakNotiTitle,
                body: loc.streakNotiBody,
                when: times[0],
            );
            await _schedule(
                id: _reminderId,
                title: loc.workoutReminderTitle,
                body: loc.workoutReminderBody,
                when: times[1],
            );
            await _schedule(
                id: _dontGiveUpId,
                title: loc.dontGiveUpNotiTitle,
                body: loc.dontGiveUpNotiBody,
                when: times[2],
            );
        } catch (e) {
            debugPrint('laterNoti failed: $e');
        }
    }

    //one notification shown right away, in its own try/catch like _schedule
    static Future<void> _showNow({
        required int id,
        required String title,
        required String body,
    }) async {
        try {
            await flutterLocalNotificationsPlugin.show(
                id: id,
                title: title,
                body: body,
                notificationDetails: _details(title, body),
            );
        } catch (e) {
            debugPrint('showing notification $id failed: $e');
        }
    }

    //debug: shows every kind of notification right away, so their texts can
    //be checked on the device. Ids from _testId up, so the scheduled ones
    //(0-2) are left alone
    static Future<void> testNoti(BuildContext context) async {
        try {
            //looked up before the first await: the screen may be gone after it
            final AppLocalizations loc = AppLocalizations.of(context)!;

            await _showNow(
                id: _testId,
                title: loc.welcomeNotiTitle,
                body: loc.welcomeNotiBody,
            );
            await _showNow(
                id: _testId + 1,
                title: loc.streakNotiTitle,
                body: loc.streakNotiBody,
            );
            await _showNow(
                id: _testId + 2,
                title: loc.workoutReminderTitle,
                body: loc.workoutReminderBody,
            );
            await _showNow(
                id: _testId + 3,
                title: loc.dontGiveUpNotiTitle,
                body: loc.dontGiveUpNotiBody,
            );
        } catch (e) {
            debugPrint('testNoti failed: $e');
        }
    }

}
