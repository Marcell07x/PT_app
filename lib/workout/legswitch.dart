import "package:shared_preferences/shared_preferences.dart";

class LegSwitch {
  late int switchState;
  late int newSwitchState;

  Future<void> getSwitch() async {
      final prefs = await SharedPreferences.getInstance();
      switchState = prefs.getInt('switch') ?? 1;
  }

  Future<void> setSwitch() async {
      final prefs = await SharedPreferences.getInstance();
      newSwitchState = -switchState;
      await prefs.setInt('switch', newSwitchState);
  }
}