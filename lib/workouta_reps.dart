import 'workouta.dart';
import 'level.dart';

class WorkoutAReps extends WorkoutA {
    var Reps = [];
    late int levelR;

    Future<void> SetReps(List<Map<String, String>> workoutParts) async {
        WorkoutLevel workoutLevel = WorkoutLevel();
        await workoutLevel.getLevel(); 
        levelR = workoutLevel.level; 

        if (levelR >= 1 && levelR < 5) {
              Reps = [10];
        } else if (levelR >= 5 && levelR < 10) {
              Reps = [11];
        } else if (levelR >= 10 && levelR < 15) {
              Reps = [12];
        }

        //This should stay at the end
        for (int i = 0; i < workoutParts.length; i++) {
            workoutParts[i]['reps'] = Reps[i].toString();
        }
    }
}


 //