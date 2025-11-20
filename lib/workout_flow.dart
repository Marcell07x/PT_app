import 'package:flutter/material.dart';
import 'workout_screen.dart';
import 'workout_done_screen.dart';
import 'exercises.dart';

class WorkoutFlow extends StatefulWidget {
  @override
  _WorkoutFlowState createState() => _WorkoutFlowState();
}

class _WorkoutFlowState extends State<WorkoutFlow> {
  final List<Map<String, String>> workouts = []; // 👈 DYNAMIC
  int currentIndex = 0;

  Exercises exercises = Exercises();

  void initializeWorkouts() {
    setState(() {
      workouts.add(exercises.push['1']!);
      
    
      }
    );
  } 

  @override
  void initState() {
    super.initState();
    initializeWorkouts();
  }

  void goToNext() {
    if (currentIndex < workouts.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CongratulationsScreen()),
      );
    }
  }

  void goToPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Edzés')),
        body: Center(child: Text('Gyakorlatok betöltése...')),
      );
    }

    final isLastWorkout = currentIndex == workouts.length - 1;
    
    return WorkoutScreen(
      videoPath: workouts[currentIndex]['videoPath']!,
      description: workouts[currentIndex]['description']!,
      reps: workouts[currentIndex]['reps']!, // 👈 REPS STRING ÁTVITEL
      buttonText: isLastWorkout ? 'Befejezés' : 'Következő',
      onNextPressed: goToNext,
      onPreviousPressed: goToPrevious,
      currentIndex: currentIndex,
      totalWorkouts: workouts.length,
    );
  }
}