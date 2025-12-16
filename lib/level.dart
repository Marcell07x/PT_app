import "package:shared_preferences/shared_preferences.dart";

class WorkoutLevel {
    late int level;

    Future<void> getLevel() async {
        final prefs = await SharedPreferences.getInstance();
        level = prefs.getInt('level') ?? 1;
    }

}