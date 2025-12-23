import 'exercises.dart';
import 'level.dart';
import "package:shared_preferences/shared_preferences.dart";


class WorkoutA {
    late int levelE;
    Exercises exercises = Exercises();
    WorkoutLevel workoutLevel = WorkoutLevel();

    List<Map<String, String>> workout_parts = [];

    late int pushe;
    late int pulle;
    late int legse;
    late int coree;

    late var pushex;
    late var pullex;
    late var legsex;
    late var coreex;

    Future<void> SetExer() async {
        await workoutLevel.getLevel(); 
        levelE = workoutLevel.level;

        final prefs = await SharedPreferences.getInstance();

        pushe = prefs.getInt('pushe')!;
        pulle = prefs.getInt('pulle')!;
        legse = prefs.getInt('legse')!;
        coree = prefs.getInt('coree')!;

        pushex = exercises.push[pushe.toString()];
        pullex = exercises.pull[pulle.toString()];
        legsex = exercises.legs[legse.toString()];
        coreex = exercises.core[coree.toString()];

        if (levelE < 30) {
            workout_parts = [{...pushex}];
        } else if (levelE < 60) {
            workout_parts = [{...pushex}, {...pushex}];
        }
    }
}