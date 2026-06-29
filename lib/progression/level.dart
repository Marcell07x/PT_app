import "package:shared_preferences/shared_preferences.dart";

class WorkoutLevel {
    late int level;

    Future<void> getLevel() async {
        final prefs = await SharedPreferences.getInstance();
        level = prefs.getInt('level') ?? 1;
    }

    Future<void> setLevel() async {
        final prefs = await SharedPreferences.getInstance();

        int currentLevel = prefs.getInt('level') ?? 1;
        int inc = prefs.getInt('incspeed') ?? 1;
        
        int newLevel = currentLevel + inc;

        await prefs.setInt('level', newLevel);
    }

}