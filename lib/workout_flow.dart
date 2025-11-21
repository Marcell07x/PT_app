import 'package:flutter/material.dart';
import 'workout_screen.dart';
import 'workout_done_screen.dart';
import 'workouta.dart';
import 'workouta_reps.dart';

class WorkoutFlow extends StatefulWidget {
    @override
    _WorkoutFlowState createState() => _WorkoutFlowState();
}

class _WorkoutFlowState extends State<WorkoutFlow> {
    WorkoutA workouta = WorkoutA();
    WorkoutAReps workoutareps = WorkoutAReps();
    final List<Map<String, String>> workouts = []; 
    int currentIndex = 0;

    void initializeWorkouts() {
        setState(() {
            workouts.addAll(workouta.workout_parts);
            print(workouts);
        });
    } 

    @override
    void initState() {
        super.initState();
        workouta.SetExer();
        workoutareps.SetReps(workouta.workout_parts);
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
            reps: workouts[currentIndex]['reps']!,
            buttonText: isLastWorkout ? 'Befejezés' : 'Következő',
            onNextPressed: goToNext,
            onPreviousPressed: goToPrevious,
            currentIndex: currentIndex,
            totalWorkouts: workouts.length,
        );
    }
}