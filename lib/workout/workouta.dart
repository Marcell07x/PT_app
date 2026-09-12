import 'package:getshap/workout/exercises.dart';
import 'package:getshap/core/level.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:getshap/workout/legswitch.dart';

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
    late var _pushexp;
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
        //from 90 the push steps up one variation instead of the reps climbing
        //past 15, one slot at a time
        _pushexp = exercises.push[_pushe + 1]!;
        _pullex = exercises.pull[_pulle]!;
        //the three leg families sit next to each other in the legs map, so the
        //switch state is itself the offset from the level base index
        _legsex = exercises.legs[_legse + legSwitch.switchState - 1]!;

        if (_levelE < 30) {
            workout_partsA = [{..._pushex}];
        } else if (_levelE < 60) {
            workout_partsA = [{..._pushex}, {..._pushex}];
        } else if (_levelE < 85) {
            workout_partsA = [{..._pushex}, {..._pullex}, {..._pushex}];
        } else if (_levelE < 90) {
            workout_partsA = [{..._pushex}, {..._pullex}, {..._pushex}, {..._pullex}];
        } else if (_levelE < 95) {
            // 90+: the first push set is the one that would have gone past 15.
            workout_partsA = [{..._pushexp}, {..._pullex}, {..._pushex}, {..._pullex}];
        } else if (_levelE < 110) {
            workout_partsA = [{..._pushexp}, {..._pullex}, {..._pushexp}, {..._pullex}];
        } else if (_levelE < 115) {
            // the third push set enters low, so it stays on the base variation.
            workout_partsA = [{..._pushexp}, {..._pullex}, {..._pushexp}, {..._pullex}, {..._pushex}];
        } else if (_levelE < 125) {
            workout_partsA = [{..._pushexp}, {..._pullex}, {..._pushexp}, {..._pullex}, {..._pushex}, {..._pullex},];
        } else if (_levelE < 135) {
            // 125+: the third set has caught up too.
            workout_partsA = [{..._pushexp}, {..._pullex}, {..._pushexp}, {..._pullex}, {..._pushexp}, {..._pullex},];
        } else if (_levelE < 150) {
            workout_partsA = [{..._pushexp}, {..._pullex}, {..._legsex}, {..._pushexp},
                             {..._pullex}, {..._legsex}, {..._pushexp}, {..._pullex}, {..._legsex}];
        }
    }
}
