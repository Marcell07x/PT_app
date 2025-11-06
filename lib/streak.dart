import 'package:shared_preferences/shared_preferences.dart';

class StreakManager {
  static int _streak = 0;
  static late SharedPreferences _prefs;

  // Initialize streak manager
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _streak = _prefs.getInt('streak') ?? 0;
  }

  // Get current streak
  static int get streak => _streak;

  // Increment streak
  static Future<void> incrementStreak() async {
    _streak++;
    await _prefs.setInt('streak', _streak);
  }

  // Reset streak (if needed)
  static Future<void> resetStreak() async {
    _streak = 0;
    await _prefs.setInt('streak', _streak);
  }

  // Set streak to specific value
  static Future<void> setStreak(int value) async {
    _streak = value;
    await _prefs.setInt('streak', _streak);
  }
}