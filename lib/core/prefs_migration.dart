import 'package:shared_preferences/shared_preferences.dart';

/// One-time rewrites of stored preferences after a change to what those
/// values mean.
///
/// The version stamp is what makes this safe to call on every launch: the
/// steps below are not all idempotent (remapping `legse` a second time would
/// find no match and reset the user to the beginner level), so a migration
/// must run exactly once per install. On a fresh install nothing is there to
/// migrate and only the stamp is written, which is correct — that install is
/// already on the current schema.
class PrefsMigration {
    static const int _currentVersion = 2;

    /// Must run before anything reads `legse`, `switch` or `pushe`.
    static Future<void> run() async {
        final prefs = await SharedPreferences.getInstance();
        final int version = prefs.getInt('prefsVersion') ?? 0;
        if (version >= _currentVersion) return;

        if (version < 1) await _toV1(prefs);
        if (version < 2) await _toV2(prefs);

        await prefs.setInt('prefsVersion', _currentVersion);
    }

    /// v1: a third leg family (glutes) joined squats and lunges, so `legs` in
    /// exercises.dart went from a 2-wide stride to a 3-wide one, and the leg
    /// switch went from -1/1 to a 1 -> 2 -> 3 cycle.
    static Future<void> _toV1(SharedPreferences prefs) async {
        //read before overwriting: the core switch is seeded from the old value
        final int? oldSwitch = prefs.getInt('switch');

        //`legse` always points at a squat. The same squats used to sit at
        //1/3/5 and now sit at 1/4/7.
        final int? legse = prefs.getInt('legse');
        if (legse != null) {
            const Map<int, int> remap = {1: 1, 3: 4, 5: 7};
            await prefs.setInt('legse', remap[legse] ?? 1);
        }

        //-1 was the lunge day, and lunges are state 2 in the new cycle
        if (oldSwitch != null && (oldSwitch < 1 || oldSwitch > 3)) {
            await prefs.setInt('switch', 2);
        }

        //core alternation moved off the leg switch onto its own key; seed it
        //from the old leg switch so the abs / lower-back order does not restart
        if (!prefs.containsKey('coreSwitch')) {
            await prefs.setInt('coreSwitch', oldSwitch == -1 ? -1 : 1);
        }
    }

    /// v2: a new push variation (diamond table push-up) was inserted between
    /// the table and the knee push-up, so the knee push-up and everything
    /// above it moved one index on.
    static Future<void> _toV2(SharedPreferences prefs) async {
        //the converter is the only writer of `pushe` and can only have written
        //1..4, so the table covers every value that can actually be stored; the
        //fallback only guards against a corrupted one
        final int? pushe = prefs.getInt('pushe');
        if (pushe != null) {
            const Map<int, int> remap = {1: 1, 2: 2, 3: 4, 4: 5};
            await prefs.setInt('pushe', remap[pushe] ?? 2);
        }
    }
}
