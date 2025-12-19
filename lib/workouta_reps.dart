import 'workouta.dart';
import 'level.dart';

class WorkoutAReps extends WorkoutA {
    var Reps = [];
    late int levelR;

    Future<void> SetReps(List<Map<String, String>> workoutParts) async {
        WorkoutLevel workoutLevel = WorkoutLevel();
        await workoutLevel.getLevel(); 

        workoutlevel.level = levelR; 

        if (levelR == 1) {
            Reps.add('10');
        }

        if (levelR == 5 || ) // Problem: if the level increment skips a difficulty increase, that increase won't happen

        for (int i = 0; i < workoutParts.length; i++) {
            workoutParts[i]['reps'] = Reps[i];
        }
    }
}


 //