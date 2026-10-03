import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:getshap/notifications/schedule_noti.dart';

void main() {
    tzdata.initializeTimeZones();
    final tz.Location budapest = tz.getLocation('Europe/Budapest');

    tz.TZDateTime at(int year, int month, int day, int hour, [int minute = 0]) =>
        tz.TZDateTime(budapest, year, month, day, hour, minute);

    //2026-10-05 is a Monday
    tz.TZDateTime oct(int day, int hour, [int minute = 0]) =>
        at(2026, 10, day, hour, minute);

    group('after-workout notifications', () {
        test('beginner: next day, a day later, four days after the next day', () {
            expect(ScheduleNotifications.afterWorkoutTimes(oct(5, 18), 1),
                [oct(6, 18), oct(7, 18), oct(10, 18)]);
        });

        test('advanced with a rest day: Wed, Thu, Sun', () {
            expect(ScheduleNotifications.afterWorkoutTimes(oct(5, 18), 2),
                [oct(7, 18), oct(8, 18), oct(11, 18)]);
        });

        test('full week after a Friday workout: Mon, Tue, Fri', () {
            expect(ScheduleNotifications.afterWorkoutTimes(oct(9, 18), 3),
                [oct(12, 18), oct(13, 18), oct(16, 18)]);
        });

        test('0 days counts as 1, so nothing fires on the workout day', () {
            expect(ScheduleNotifications.afterWorkoutTimes(oct(5, 18), 0),
                ScheduleNotifications.afterWorkoutTimes(oct(5, 18), 1));
        });

        test('late evening and early morning are moved into daytime', () {
            expect(ScheduleNotifications.afterWorkoutTimes(oct(5, 23, 30), 1),
                [oct(6, 21), oct(7, 21), oct(10, 21)]);
            expect(ScheduleNotifications.afterWorkoutTimes(oct(5, 5), 1),
                [oct(6, 6), oct(7, 6), oct(10, 6)]);
        });

        test('the clock time stays across the autumn DST change (2026-10-25)', () {
            //24 hours after 10-24 18:00 would be 10-25 17:00
            expect(ScheduleNotifications.afterWorkoutTimes(oct(24, 18), 1),
                [oct(25, 18), oct(26, 18), oct(29, 18)]);
        });

        test('the clock time stays across the spring DST change (2027-03-28)', () {
            //24 hours after 03-27 21:00 would be 03-28 22:00, outside daytime
            expect(ScheduleNotifications.afterWorkoutTimes(at(2027, 3, 26, 21, 30), 1),
                [at(2027, 3, 27, 21), at(2027, 3, 28, 21), at(2027, 3, 31, 21)]);
        });
    });

    group('welcome notification', () {
        test('one day later at the same time', () {
            expect(ScheduleNotifications.welcomeTime(oct(5, 18, 15)), oct(6, 18, 15));
        });

        test('moved into daytime', () {
            expect(ScheduleNotifications.welcomeTime(oct(5, 22)), oct(6, 21));
        });
    });
}
