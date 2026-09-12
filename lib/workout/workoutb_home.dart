import 'package:getshap/workout/exercises.dart';
import 'package:getshap/core/level.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:getshap/workout/legswitch.dart';
import 'package:getshap/workout/coreswitch.dart';
import 'package:getshap/workout/pullprogression.dart';

class WorkoutBHome {
    late int _levelE;
    Exercises exercises = Exercises();
    WorkoutLevel workoutLevel = WorkoutLevel();
    LegSwitch legSwitch = LegSwitch();
    CoreSwitch coreSwitch = CoreSwitch();

    List<Map<String, String>> workout_partsBHome = [];

    late int _pushe;
    late int _pulle;
    late int _legse;

    late var _coreex;
    late var _pushex;
    late var _pullex;
    late var _legsex;

    late var _pushexp;
    late var _legsexp;

    late var _pushexpp;
    late var _legsexpp;

    Future<void> SetExerBHome() async {
        await legSwitch.getSwitch();
        await coreSwitch.getSwitch();
        await workoutLevel.getLevel(); 
        _levelE = workoutLevel.level;

        final prefs = await SharedPreferences.getInstance();

        _pushe = prefs.getInt('pushe')!;
        _pulle = prefs.getInt('pulle')!;
        _legse = prefs.getInt('legse')!;

        // The three leg families sit next to each other in the legs map, so the
        // switch state is the offset from a level's base index (0 = squat,
        // 1 = lunge, 2 = glute) and one full level step is 3 indices on.
        final int legsV = legSwitch.switchState - 1;

        // From level 90 the push has already stepped up one variation, so workout
        // B starts from pushe + 1 and every tier shifts up with it.
        _pushex = exercises.push[_pushe + 1]!;
        //from 350 the pull steps up a variation, unless the user is 60+
        final bool harderPullEx = await PullProgression.steppedUp(_levelE);
        _pullex = exercises.pull[harderPullEx ? _pulle + 1 : _pulle]!;
        _legsex = exercises.legs[_legse + legsV]!;

        _pushexp = exercises.push[_pushe + 2]!;
        _legsexp = exercises.legs[_legse + 3 + legsV]!;

        _pushexpp = exercises.push[_pushe + 3]!;
        _legsexpp = exercises.legs[_legse + 6 + legsV]!;

        // Core runs on its own two-state switch: back extensions on one
        // workout, abs on the next, whatever the legs are doing.
        final abs = exercises.core[1]!;
        final lowerBack = exercises.core[2]!;
        _coreex = coreSwitch.switchState == 1 ? lowerBack : abs;

        if (_levelE < 190) {
            // 150-189: still the variation the user stepped up to at 90; 190 brings the next one.
            workout_partsBHome = [
                {..._pushex}, {..._pullex}, {..._legsex},
                {..._pushex}, {..._pullex}, {..._legsex},
                {..._pushex}, {..._pullex}, {..._legsex}
            ];
        } else if (_levelE < 230) {
            // 190+: the next push variation enters as a single set, placed SECOND (idx3)
            // so a lighter set leads into it - extra ramp-up for the new variation.
            workout_partsBHome = [
                {..._pushex}, {..._pullex}, {..._legsex},
                {..._pushexp}, {..._pullex}, {..._legsex},
                {..._pushex}, {..._pullex}, {..._legsex}
            ];
        } else if (_levelE < 310) {
            // 230+: second harder-push set added.
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsex},
                {..._pushexp}, {..._pullex}, {..._legsex},
                {..._pushex}, {..._pullex}, {..._legsex}
            ];
        } else if (_levelE < 350) {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsex},
                {..._pushexp}, {..._pullex}, {..._legsex},
                {..._pushexp}, {..._pullex}, {..._legsex}
            ];
        } else if (_levelE < 390) {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsex},
                {..._pushexp}, {..._pullex}, {..._legsex},
                {..._pushexp}, {..._pullex}, {..._legsex},
                {..._pushex}, {..._pullex}, {..._legsex}
            ];
        } else if (_levelE < 430) {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsexp},
                {..._pushexp}, {..._pullex}, {..._legsexp},
                {..._pushexp}, {..._pullex}, {..._legsexp},
                {..._pushex}, {..._pullex}, {..._legsexp}
            ];
        } else if (_levelE < 470) {
            // 430+: core enters, appended to the first two blocks.
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsexp}, {..._coreex},
                {..._pushexp}, {..._pullex}, {..._legsexp}, {..._coreex},
                {..._pushexp}, {..._pullex}, {..._legsexp},
                {..._pushexp}, {..._pullex}, {..._legsexp}
            ];
        } else if (_levelE < 510) {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsexp}, {..._coreex},
                {..._pushexpp}, {..._pullex}, {..._legsexpp}, {..._coreex},
                {..._pushexp}, {..._pullex}, {..._legsexp},
                {..._pushexp}, {..._pullex}, {..._legsexp}
            ];
        } else {
            workout_partsBHome = [
                {..._pushexp}, {..._pullex}, {..._legsexp}, {..._coreex},
                {..._pushexpp}, {..._pullex}, {..._legsexpp}, {..._coreex},
                {..._pushexpp}, {..._pullex}, {..._legsexpp},
                {..._pushexp}, {..._pullex}, {..._legsexp}
            ];
        }
    }
}
