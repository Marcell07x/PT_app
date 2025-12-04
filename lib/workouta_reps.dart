import 'workouta.dart';
import 'level.dart';

class WorkoutAReps extends WorkoutA {
    var Reps = [];

    SetReps(List<Map<String, String>> workoutParts) {
        WorkoutLevel workoutLevel = WorkoutLevel();
        workoutLevel.getLevel();  

        for (var i in workoutParts) {

        }
        print(workoutParts);
    }
}