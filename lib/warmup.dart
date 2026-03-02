import 'exercises.dart';
import 'level.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'legswitch.dart';

class Warmup {
    late int _levelE;
    Exercises exercises = Exercises();
    WorkoutLevel workoutLevel = WorkoutLevel();
    LegSwitch legSwitch = LegSwitch();

    late int _pushe;
    late int _pulle;
    late int _legse;

    late var _pushex;
    late var _pullex;
    late var _legsex;

    Future<void> setWarmup(List<Map<String, String>> warmupParts) {
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

        
    }
}