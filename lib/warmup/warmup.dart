import 'package:getshap/workout/exercises.dart';
import 'package:getshap/core/level.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:getshap/workout/legswitch.dart';

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

        // Below 190 the base push is the hardest push in the workout, so warm up
        // one variation easier (wall push-up has nothing easier, so it stays put).
        // From 190 the harder variant is in the workout, so the base push itself
        // already works as the warm-up.
        final int warmupPushe = _levelE < 190 ? (_pushe > 1 ? _pushe - 1 : 1) : _pushe;
        _pushex = exercises.push[warmupPushe]!;
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