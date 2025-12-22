import 'exercises.dart';
import 'level.dart';
import "package:shared_preferences/shared_preferences.dart";


class WorkoutA {
    late int levelE;
    Exercises exercises = Exercises();
    WorkoutLevel workoutLevel = WorkoutLevel();

    List<Map<String, String>> workout_parts = [];

    late String pushe;
    late String pulle;
    late String legse;
    late String coree;

    late var pushex;
    late var pullex;
    late var legsex;
    late var coreex;

    Future<void> SetExer() async {
        await workoutLevel.getLevel(); 
        levelE = workoutLevel.level;

        final prefs = await SharedPreferences.getInstance();

        pushe = prefs.getInt('pushe')!.toString();
        pulle = prefs.getInt('pulle')!.toString();
        legse = prefs.getInt('legse')!.toString();
        coree = prefs.getInt('coree')!.toString();

        pushex = exercises.push[pushe];
        pullex = exercises.pull[pulle];
        legsex = exercises.legs[legse];
        coreex = exercises.core[coree];

        if (levelE <= 25) {
            workout_parts.add(pushex);
        } 
    }
}