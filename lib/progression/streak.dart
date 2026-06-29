import 'package:shared_preferences/shared_preferences.dart';

class StreakManager {
    static int _streak = 0;
    static late SharedPreferences _prefs;

    static Future<void> init() async {
        _prefs = await SharedPreferences.getInstance();
        _streak = _prefs.getInt('streak') ?? 0;
    }

    static int get streak => _streak;

    static Future<void> incrementStreak() async {
        _streak++;
        await _prefs.setInt('streak', _streak);
    }

    static Future<void> resetStreak() async {
        _streak = 0;
        await _prefs.setInt('streak', _streak);
    }

    static Future<void> setStreak(int value) async {
        _streak = value;
        await _prefs.setInt('streak', _streak);
    }
}