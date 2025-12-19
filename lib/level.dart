import "package:shared_preferences/shared_preferences.dart";

class WorkoutLevel {
    late int level;
    late int resultLevel;
    late int roundedResultLevel;
    late int incSpeed;
    late int previousStep;
    late int newStep;
    
    Future<void> getLevel() async {
        final prefs = await SharedPreferences.getInstance();
        level = prefs.getInt('level') ?? 1;
    }

    Future<void> setLevel() async {
        final prefs = await SharedPreferences.getInstance();

        // incSpeed has not been set

        resultLevel = level + incSpeed;

        previousStep = level ~/ 5;
        newStep = resultLevel ~/ 5;

        if (newStep > previousStep) {
            roundedResultLevel = newStep * 5;
        }

        await prefs.setInt('level', roundedResultLevel);
    }

}