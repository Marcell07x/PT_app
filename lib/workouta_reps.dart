import 'workouta.dart';
import 'level.dart';

class WorkoutAReps extends WorkoutA {
    var Reps = [];

    Future<void> SetReps(List<Map<String, String>> workoutParts) async {
        WorkoutLevel workoutLevel = WorkoutLevel();
        await workoutLevel.getLevel();  

        if (workoutLevel.level == 1) {
            Reps.add('10');
        }

        for (int i = 0; i < workoutParts.length; i++) {
            workoutParts[i]['reps'] = Reps[i];
        }
    }
}


 //