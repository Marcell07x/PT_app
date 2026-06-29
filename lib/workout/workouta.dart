import 'exercises.dart';
import 'level.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'legswitch.dart';

class WorkoutA {
    late int _levelE;
    Exercises exercises = Exercises();
    WorkoutLevel workoutLevel = WorkoutLevel();
    LegSwitch legSwitch = LegSwitch();

    List<Map<String, String>> workout_partsA = [];

    late int _pushe;
    late int _pulle;
    late int _legse;

    late var _pushex;
    late var _pullex;
    late var _legsex;

    Future<void> SetExerA() async {
        await legSwitch.getSwitch();
        await workoutLevel.getLevel(); 
        _levelE = workoutLevel.level;

        final prefs = await SharedPreferences.getInstance();

        _pushe = prefs.getInt('pushe')!;
        _pulle = prefs.getInt('pulle')!;
        _legse = prefs.getInt('legse')!;

        _pushex = exercises.push[_pushe]!;
        _pullex = exercises.pull[_pulle]!;
        _legsex = exercises.legs[_legse]!;

        if (_levelE < 30) {
            workout_partsA = [{..._pushex}];
        } else if (_levelE < 60) {
            workout_partsA = [{..._pushex}, {..._pushex}];
        } else if (_levelE < 85) {
            workout_partsA = [{..._pushex}, {..._pullex}, {..._pushex}];
        } else if (_levelE < 90) {
            workout_partsA = [{..._pushex}, {..._pullex}, {..._pushex}, {..._pullex}];
        } else if (_levelE < 110) {
            workout_partsA = [{..._pushex}, {..._pullex}, {...exercises.push[_pushe+1]!}, {..._pullex}];
        } else if (_levelE < 115) {
            workout_partsA = [{..._pushex}, {..._pullex}, {...exercises.push[_pushe+1]!}, {..._pullex}, {..._pushex}];
        } else if (_levelE < 130) {
            workout_partsA = [{..._pushex}, {..._pullex}, {...exercises.push[_pushe+1]!}, {..._pullex}, {..._pushex}, {..._pullex},];
        } else if (_levelE < 135) {
            workout_partsA = [{...exercises.push[_pushe+1]!}, {..._pullex}, {...exercises.push[_pushe+1]!}, {..._pullex}, {..._pushex}, {..._pullex},];
        } else if (_levelE < 150 && legSwitch.switchState == 1) {
            workout_partsA = [{...exercises.push[_pushe+1]!}, {..._pullex}, {..._legsex}, {...exercises.push[_pushe+1]!},
                             {..._pullex}, {..._legsex}, {..._pushex}, {..._pullex}, {..._legsex}];
        } else if (_levelE < 150 && legSwitch.switchState == (-1)) {
            workout_partsA = [{...exercises.push[_pushe+1]!}, {..._pullex}, {...exercises.legs[_legse+1]!}, {...exercises.push[_pushe+1]!},
                             {..._pullex}, {...exercises.legs[_legse+1]!}, {..._pushex}, {..._pullex}, {...exercises.legs[_legse+1]!}];
        }
    }
}