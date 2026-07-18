import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

//goal: a debug-only clock that can be pushed forward in whole days, so
//      the streak / signal / weekly-counter systems can be driven through
//      several days without touching the device date. In release builds
//      (or with a zero offset) it is exactly DateTime.now(), so it changes
//      nothing for real users.
class DebugClock {
    static int _offsetDays = 0;

    //load the stored offset into memory. Call once at app start before any
    //now() is used. Always 0 outside debug builds.
    static Future<void> load() async {
        if (!kDebugMode) {
            _offsetDays = 0;
            return;
        }
        final prefs = await SharedPreferences.getInstance();
        _offsetDays = prefs.getInt('debugDayOffset') ?? 0;
    }

    //the current time the whole streak/signal logic should use
    static DateTime now() {
        if (!kDebugMode || _offsetDays == 0) return DateTime.now();
        return DateTime.now().add(Duration(days: _offsetDays));
    }

    //push the simulated clock forward by [days] and persist it
    static Future<void> advance(int days) async {
        if (!kDebugMode) return;
        final prefs = await SharedPreferences.getInstance();
        _offsetDays = (prefs.getInt('debugDayOffset') ?? 0) + days;
        await prefs.setInt('debugDayOffset', _offsetDays);
    }

    static int get offsetDays => kDebugMode ? _offsetDays : 0;
}
