import 'workouta.dart';

class WorkoutAReps extends WorkoutA{

  
  var Reps = [];

  SetReps(List<Map<String, String>> workoutParts) {

    for (var i in workoutParts) {
      i['reps'] = '12';
    }
    print(workoutParts);
  }

}