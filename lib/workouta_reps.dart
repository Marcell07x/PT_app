import 'workouta.dart';
import 'level.dart';

class WorkoutAReps extends WorkoutA {
    var Reps = [];
    late int levelR;

    Future<void> SetReps(List<Map<String, String>> workoutParts) async {
        WorkoutLevel workoutLevel = WorkoutLevel();
        await workoutLevel.getLevel(); 
        levelR = workoutLevel.level; 

        if (levelR < 5) {
            Reps = [10];
        } else if (levelR < 10) {
            Reps = [11];
        } else if (levelR < 15) {
            Reps = [12];
        } else if (levelR < 20) {
            Reps = [13];
        } else if (levelR < 25) {
            Reps = [14];
        } else if (levelR < 30) {
            Reps = [15];
        } else if (levelR < 35) {
            Reps = [15, 5];
        } else if (levelR < 40) {
            Reps = [15, 6];
        } else if (levelR < 45) {
            Reps = [15, 7];
        } else if (levelR < 50) {
            Reps = [15, 8];
        } else if (levelR < 55) {
            Reps = [15, 9];
        } else if (levelR < 60) {
            Reps = [15, 10];
        }
        
        //This should stay at the end
        for (int i = 0; i < Reps.length; i++) {
            workoutParts[i]['reps'] = Reps[i].toString();
        }
    }
}


 //