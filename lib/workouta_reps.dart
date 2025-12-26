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
        } else if (levelR < 65) {
            Reps = [15, 5, 10];
        } else if (levelR < 70) {
            Reps = [15, 10, 10];
        } else if (levelR < 75) {
            Reps = [15, 10, 12];
        } else if (levelR < 80) {
            Reps = [15, 15, 12];
        } else if (levelR < 85) {
            Reps = [15, 15, 15];
        } else if (levelR < 90) {
            Reps = [15, 15, 15, 5];
        } else if (levelR < 95) {
            Reps = [10, 15, 10, 7];
        } else if (levelR < 100) {
            Reps = [12, 15, 10, 10];
        } else if (levelR < 105) {
            Reps = [15, 15, 10, 10];
        } else if (levelR < 110) {
            Reps = [15, '10-15', 12, '10-15'];
        } else if (levelR < 115) {
            Reps = [15, '10-15', 12, '10-15', 5];
        } else if (levelR < 120) {
            Reps = [15, '10-15', 12, '10-15', 5, 5];
        } else if (levelR < 125) {
            Reps = [15, '10-15', 12, '10-15', 6, 5];
        } else if (levelR < 130) {
            Reps = [15, '10-15', 12, '10-15', 6, 6];
        } else if (levelR < 135) {
            Reps = [12, '10-15', 10, '10-15', 6, 6];
        } else if (levelR < 140) {
            Reps = [12, '10-15', 5, 10, '10-15', 5, 6, 6, 5];
        } else if (levelR < 145) {
            Reps = [12, '10-15', 7, 10, '10-15', 7, 6, 6, 7];
        } else if (levelR < 150) {
            Reps = [12, '10-15', 10, 10, '10-15', 10, 6, 6, 5];
        }
        
        //This should stay at the end
        for (int i = 0; i < Reps.length; i++) {
            workoutParts[i]['reps'] = Reps[i].toString();
        }
    }
}


 //