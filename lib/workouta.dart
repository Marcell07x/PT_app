import 'exercises.dart';
import 'level.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'legswitch.dart';

class WorkoutA {
    late int levelE;
    Exercises exercises = Exercises();
    WorkoutLevel workoutLevel = WorkoutLevel();
    LegSwitch legSwitch = LegSwitch();

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
        await legSwitch.getSwitch();
        await workoutLevel.getLevel(); 
        levelE = workoutLevel.level;

        final prefs = await SharedPreferences.getInstance();

        pushe = prefs.getInt('pushe')!;
        pulle = prefs.getInt('pulle')!;
        legse = prefs.getInt('legse')!;
        coree = prefs.getInt('coree')!;

        pushex = exercises.push[pushe]!;
        pullex = exercises.pull[pulle]!;
        legsex = exercises.legs[legse]!;
        coreex = exercises.core[coree]!;

        if (levelE < 30) {
            workout_parts = [{...pushex}];
        } else if (levelE < 60) {
            workout_parts = [{...pushex}, {...pushex}];
        } else if (levelE < 85) {
            workout_parts = [{...pushex}, {...pullex}, {...pushex}];
        } else if (levelE < 90) {
            workout_parts = [{...pushex}, {...pullex}, {...pushex}, {...pullex}];
        } else if (levelE < 110) {
            workout_parts = [{...pushex}, {...pullex}, {...exercises.push[pushe+1]!}, {...pullex}];
        } else if (levelE < 115) {
            workout_parts = [{...pushex}, {...pullex}, {...exercises.push[pushe+1]!}, {...pullex}, {...pushex}];
        } else if (levelE < 130) {
            workout_parts = [{...pushex}, {...pullex}, {...exercises.push[pushe+1]!}, {...pullex}, {...pushex}, {...pullex},];
        } else if (levelE < 135) {
            workout_parts = [{...exercises.push[pushe+1]!}, {...pullex}, {...exercises.push[pushe+1]!}, {...pullex}, {...pushex}, {...pullex},];
        } else if (levelE < 150 && legSwitch.switchState == 1) {
            workout_parts = [{...exercises.push[pushe+1]!}, {...pullex}, {...legsex}, {...exercises.push[pushe+1]!},
                             {...pullex}, {...legsex}, {...pushex}, {...pullex}, {...legsex}];
        } else if (levelE < 150 && legSwitch.switchState == (-1)) {
            workout_parts = [{...exercises.push[pushe+1]!}, {...pullex}, {...exercises.legs[legse+1]!}, {...exercises.push[pushe+1]!},
                             {...pullex}, {...exercises.legs[legse+1]!}, {...pushex}, {...pullex}, {...exercises.legs[legse+1]!}];
        }
    }
}