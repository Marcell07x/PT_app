import 'level.dart';

class WorkoutAReps{
    var _Reps = [];
    late int _levelR;

    Future<void> SetRepsA(List<Map<String, String>> workoutParts) async {
        WorkoutLevel workoutLevel = WorkoutLevel();
        await workoutLevel.getLevel(); 
        _levelR = workoutLevel.level; 

        if (_levelR < 5) {
            _Reps = [10];
        } else if (_levelR < 10) {
            _Reps = [11];
        } else if (_levelR < 15) {
            _Reps = [12];
        } else if (_levelR < 20) {
            _Reps = [13];
        } else if (_levelR < 25) {
            _Reps = [14];
        } else if (_levelR < 30) {
            _Reps = [15];
        } else if (_levelR < 35) {
            _Reps = [15, 5];
        } else if (_levelR < 40) {
            _Reps = [15, 6];
        } else if (_levelR < 45) {
            _Reps = [15, 7];
        } else if (_levelR < 50) {
            _Reps = [15, 8];
        } else if (_levelR < 55) {
            _Reps = [15, 9];
        } else if (_levelR < 60) {
            _Reps = [15, 10];
        } else if (_levelR < 65) {
            _Reps = [15, 5, 10];
        } else if (_levelR < 70) {
            _Reps = [15, 10, 10];
        } else if (_levelR < 75) {
            _Reps = [15, 10, 12];
        } else if (_levelR < 80) {
            _Reps = [15, 15, 12];
        } else if (_levelR < 85) {
            _Reps = [15, 15, 15];
        } else if (_levelR < 90) {
            _Reps = [15, 15, 15, 5];
        } else if (_levelR < 95) {
            _Reps = [10, 15, 10, 7];
        } else if (_levelR < 100) {
            _Reps = [12, 15, 10, 10];
        } else if (_levelR < 105) {
            _Reps = [15, 15, 10, 10];
        } else if (_levelR < 110) {
            _Reps = [15, '10-15', 12, '10-15'];
        } else if (_levelR < 115) {
            _Reps = [15, '10-15', 12, '10-15', 5];
        } else if (_levelR < 120) {
            _Reps = [15, '10-15', 12, '10-15', 5, 5];
        } else if (_levelR < 125) {
            _Reps = [15, '10-15', 12, '10-15', 6, 5];
        } else if (_levelR < 130) {
            _Reps = [15, '10-15', 12, '10-15', 6, 6];
        } else if (_levelR < 135) {
            _Reps = [12, '10-15', 10, '10-15', 6, 6];
        } else if (_levelR < 140) {
            _Reps = [12, '10-15', 5, 10, '10-15', 5, 6, 6, 5];
        } else if (_levelR < 145) {
            _Reps = [12, '10-15', 7, 10, '10-15', 7, 6, 6, 7];
        } else if (_levelR < 150) {
            _Reps = [12, '10-15', 10, 10, '10-15', 10, 6, 6, 5];
        }
        
        for (int i = 0; i < _Reps.length; i++) {
            workoutParts[i]['reps'] = _Reps[i].toString();
        }
    }
}