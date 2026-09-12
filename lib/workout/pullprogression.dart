import "package:shared_preferences/shared_preferences.dart";

/// Whether the pull has progressed past the bag row.
///
/// The rule lives here because both the workout and the warm-up need it, and
/// two copies of it would drift apart.
class PullProgression {
    /// From 350 the pull steps up to the next variation, but never for the
    /// 60+ age group (age == 3) — that exercise is not appropriate for them.
    static Future<bool> steppedUp(int level) async {
        final prefs = await SharedPreferences.getInstance();
        return level >= 300 && (prefs.getInt('age') ?? 0) != 3;
    }
}
