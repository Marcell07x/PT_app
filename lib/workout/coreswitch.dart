import "package:shared_preferences/shared_preferences.dart";

/// Which core exercise the next workout uses: 1 -> back extensions, -1 -> abs.
///
/// Core alternation used to ride on [LegSwitch], but that one now cycles
/// through three leg families, so the core has its own two-state switch and
/// keeps flipping on every workout as before.
class CoreSwitch {
  late int switchState;
  late int newSwitchState;

  Future<void> getSwitch() async {
      final prefs = await SharedPreferences.getInstance();
      switchState = prefs.getInt('coreSwitch') ?? 1;
  }

  Future<void> setSwitch() async {
      final prefs = await SharedPreferences.getInstance();
      newSwitchState = -switchState;
      await prefs.setInt('coreSwitch', newSwitchState);
  }
}
