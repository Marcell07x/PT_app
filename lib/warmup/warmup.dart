import 'exercises.dart';
import 'level.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'legswitch.dart';

class Warmup {
    late int _levelE;
    late int _switch;
    Exercises exercises = Exercises();
    WorkoutLevel workoutLevel = WorkoutLevel();
    LegSwitch legSwitch = LegSwitch();

    List<Map<String, String>> warmup_parts = [];

    late int _pushe;
    late int _pulle;
    late int _legse;

    late var _pushex;
    late var _pullex;
    late var _legsex;
    late var _legsexl;
    late var _lightpullex;
    late var _runinplace;

    Future<void> setWarmup() async {
        await legSwitch.getSwitch();
        await workoutLevel.getLevel(); 
        _levelE = workoutLevel.level;
        _switch = legSwitch.switchState;

        final prefs = await SharedPreferences.getInstance();

        _pushe = prefs.getInt('pushe')!;
        _pulle = prefs.getInt('pulle')!;
        _legse = prefs.getInt('legse')!;

        _pushex = exercises.push[_pushe]!;
        _pullex = exercises.pull[_pulle]!;

        if (_legse >= 3) {       
            _legsex = exercises.legs[3]!;
            _legsexl = exercises.legs[4]!;
        } else {
            _legsex = exercises.legs[1];
            _legsexl = exercises.legs[2];
        }

        _lightpullex = exercises.warmUpExer[1];
        _runinplace = exercises.warmUpExer[2];

        if(_levelE > 129 && _levelE < 150) {
            warmup_parts = [{..._pushex}, {..._lightpullex}];
        } else if (_levelE > 129 && _levelE < 270 && _legse == 1) {
            warmup_parts = [{..._pushex}, {..._lightpullex}, {..._runinplace}];
        } else if (_levelE >= 150 && _switch == 1) {
            warmup_parts = [{..._pushex}, {..._lightpullex}, {..._legsex}];
        } else if (_levelE >= 150 && _switch == (-1)) {
            warmup_parts = [{..._pushex}, {..._lightpullex}, {..._legsexl}];
        }
    }
}