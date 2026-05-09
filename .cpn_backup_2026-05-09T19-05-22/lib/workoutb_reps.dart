import 'level.dart';

class WorkoutBReps{
    var _Reps = [];
    late int _levelR;

    Future<void> SetRepsB(List<Map<String, String>> workoutParts) async {
        WorkoutLevel workoutLevel = WorkoutLevel();
        await workoutLevel.getLevel(); 
        _levelR = workoutLevel.level; 

        if (_levelR < 170) {
            _Reps = [15, '10-15', 10, 10, '10-15', 10, 10, '10-15', 10];
        } else if (_levelR < 190) {
            _Reps = [15, '10-15', 15, 12, '10-15', 10, 10, '10-15', 10];
        } else if (_levelR < 210) {
            _Reps = [15, '10-15', 15, 12, '10-15', 12, 15, '10-15', 10];
        } else if (_levelR < 230) {
            _Reps = [15, '10-15', 15, 12, '10-15', 15, 15, '10-15', 10];
        } else if (_levelR < 250) {
            _Reps = [15, '10-15', 15, 12, '10-15', 15, 10, '10-15', 15];
        } else if (_levelR < 290) {
            _Reps = ['10-15', '10-15', '10-15', '10-15', '10-15', '10-15', 
                     '10-15', '10-15', '10-15', '10-15', '10-15', '10-15'];
        } else {
            _Reps = ['10-15', '10-15', '10-15', '15-20', '10-15', '10-15', 
                     '10-15', '15-20', '10-15', '10-15', '10-15', '10-15',
                     '10-15', '10-15'];
        }
        
        //This should stay at the end
        for (int i = 0; i < _Reps.length; i++) {
            workoutParts[i]['reps'] = _Reps[i].toString();
        }
    }
}
