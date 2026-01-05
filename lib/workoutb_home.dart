import 'exercises.dart';
import 'level.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'legswitch.dart';

class WorkoutBHome {
    late int _levelE;
    late int _switch;
    Exercises exercises = Exercises();
    WorkoutLevel workoutLevel = WorkoutLevel();
    LegSwitch legSwitch = LegSwitch();

    List<Map<String, String>> workout_partsBHome = [];

    late int _pushe;
    late int _pulle;
    late int _legse;

    late var _abs;
    late var _lowerBack;
    late var _pushex;
    late var _pullex;
    late var _legsex;
    late var _legsexl;

    late var _pushexp;
    late var _legsexp;
    late var _legsexlp;

    late var _pushexpp;
    late var _legsexpp;
    late var _legsexlpp;

    Future<void> SetExerBHome() async {
        await legSwitch.getSwitch();
        await workoutLevel.getLevel(); 
        _levelE = workoutLevel.level;
        _switch = legSwitch.switchState;

        final prefs = await SharedPreferences.getInstance();

        _pushe = prefs.getInt('pushe')!;
        _pulle = prefs.getInt('pulle')!;
        _legse = prefs.getInt('legse')!;

        _abs = exercises.core[1];
        _lowerBack = exercises.core[2];
        _pushex = exercises.push[_pushe]!;
        _pullex = exercises.pull[_pulle]!;
        _legsex = exercises.legs[_legse]!;
        _legsexl = exercises.legs[_legse+1]!;

        _pushexp = exercises.push[_pushe+1]!;
        _legsexp = exercises.legs[_legse+2]!;
        _legsexlp = exercises.legs[_legse+3]!;

        _pushexpp = exercises.push[_pushe+2]!;
        _legsexpp = exercises.legs[_legse+4]!;
        _legsexlpp = exercises.legs[_legse+5]!;

        if (_levelE < 230 && _switch == 1) {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsex}, 
                {..._pushexp},{..._pullex}, {..._legsex}, 
                {..._pushex}, {..._pullex}, {..._legsex}
            ];
        } else if (_levelE < 230 && _switch == (-1)) {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsexl},
                {..._pushexp}, {..._pullex}, {..._legsexl}, 
                {..._pushex}, {..._pullex}, {..._legsexl}
            ];
        } else if (_levelE < 250 && _switch == 1) {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsex},
                {..._pushexp}, {..._pullex}, {..._legsex},
                {..._pushex}, {..._pullex}, {..._legsex}
            ];
        } else if (_levelE < 250 && _switch == (-1)) {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsexl},
                {..._pushexp}, {..._pullex}, {..._legsexl},
                {..._pushex}, {..._pullex}, {..._legsexl}
            ];
        } else if (_levelE < 270 && _switch == 1) {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsex},
                {..._pushexp}, {..._pullex}, {..._legsex},
                {..._pushex}, {..._pullex}, {..._legsex}
            ];
        } else if (_levelE < 270 && _switch == (-1)) {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsexl},
                {..._pushexp}, {..._pullex}, {..._legsexl},
                {..._pushex}, {..._pullex}, {..._legsexl}
            ];
        } else if (_levelE < 290 && _switch == 1) {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsexp},
                {..._pushexp}, {..._pullex}, {..._legsexp},
                {..._pushexp}, {..._pullex}, {..._legsexp},
                {..._pushex}, {..._pullex}, {..._legsexp}
            ];
        } else if (_levelE < 290 && _switch == (-1)) {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsexlp},
                {..._pushexp}, {..._pullex}, {..._legsexlp},
                {..._pushexp}, {..._pullex}, {..._legsexlp},
                {..._pushex}, {..._pullex}, {..._legsexlp}
            ];
        } else if (_levelE < 310 && _switch == 1) {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsexp}, {..._lowerBack},
                {..._pushexp}, {..._pullex}, {..._legsexp}, {..._lowerBack},
                {..._pushexp}, {..._pullex}, {..._legsexp},
                {..._pushexp}, {..._pullex}, {..._legsex}
            ];
        } else if (_levelE < 310 && _switch == (-1)) {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsexlp}, {..._abs},
                {..._pushexp}, {..._pullex}, {..._legsexlp}, {..._abs},
                {..._pushexp}, {..._pullex}, {..._legsexlp},
                {..._pushexp}, {..._pullex}, {..._legsexlp}
            ];
        } else if (_levelE < 330 && _switch == 1) {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsexp}, {..._lowerBack},
                {..._pushexpp}, {..._pullex}, {..._legsexpp}, {..._lowerBack},
                {..._pushexp}, {..._pullex}, {..._legsexp},
                {..._pushexp}, {..._pullex}, {..._legsexp}
            ];
        } else if (_levelE < 330 && _switch == (-1)) {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsexlp}, {..._abs},
                {..._pushexpp}, {..._pullex}, {..._legsexlpp}, {..._abs},
                {..._pushexp}, {..._pullex}, {..._legsexlp},
                {..._pushexp}, {..._pullex}, {..._legsexlp}
            ];
        } else if (_switch == 1) {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsexp}, {..._lowerBack},
                {..._pushexpp}, {..._pullex}, {..._legsexpp}, {..._lowerBack},
                {..._pushexpp}, {..._pullex}, {..._legsexpp},
                {..._pushexp}, {..._pullex}, {..._legsexp}
            ];
        } else {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsexlp}, {..._abs},
                {..._pushexpp}, {..._pullex}, {..._legsexlpp}, {..._abs},
                {..._pushexpp}, {..._pullex}, {..._legsexlpp},
                {..._pushexp}, {..._pullex}, {..._legsexlp}
            ];
        }
    }
}