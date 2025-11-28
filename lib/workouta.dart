import 'exercises.dart';

class WorkoutA {
    Exercises exercises = Exercises();

    List<Map<String, String>> workout_parts = [];

    SetExer() {
        workout_parts.add(exercises.pull['1']!);
        print(workout_parts);
    }
}