import "package:shared_preferences/shared_preferences.dart";

/// Which of the three leg families (squat / lunge / glute) the next workout
/// uses. Cycles 1 -> 2 -> 3 -> 1 on every finished workout, so the same
/// movement comes back every third session.
class LegSwitch {
  late int switchState;
  late int newSwitchState;

  Future<void> getSwitch() async {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getInt('switch') ?? 1;
      //the switch used to be -1/1; anything outside 1..3 falls back to the
      //first variation instead of matching no branch and yielding an empty
      //workout
      switchState = (stored >= 1 && stored <= 3) ? stored : 1;
  }

  Future<void> setSwitch() async {
      final prefs = await SharedPreferences.getInstance();
      newSwitchState = switchState % 3 + 1;
      await prefs.setInt('switch', newSwitchState);
  }
}
