import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
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

    String getLocalizedExerciseName(String localizationKey, BuildContext context) {
        final loc = AppLocalizations.of(context)!;
        
        switch (localizationKey) {
            case 'wallPush': return loc.wallPush;
            case 'tablePush': return loc.tablePush;
            case 'kneePush': return loc.kneePush;
            case 'pushUp': return loc.pushUp;
            case 'inclinePush': return loc.inclinePush;
            case 'dipPush': return loc.dipPush;
            case 'bagPull': return loc.bagPull;
            case 'bwPull': return loc.bwPull;
            case 'pullup': return loc.pullup;
            case 'squat1': return loc.squat1;
            case 'lunge1': return loc.lunge1;
            case 'squat2': return loc.squat2;
            case 'lunge2': return loc.lunge2;
            case 'squat3': return loc.squat3;
            case 'lunge3': return loc.lunge3;
            case 'squat4': return loc.squat4;
            case 'lunge4': return loc.lunge4;
            case 'core1': return loc.core1;
            case 'core2': return loc.core2;
            default: return localizationKey;
        }
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
        final currentExercise = workouts[currentIndex];
        
        return WorkoutScreen(
            videoPath: currentExercise['videoPath']!,
            description: getLocalizedExerciseName(currentExercise['localizationKey']!, context),
            reps: currentExercise['reps']!,
            buttonText: isLastWorkout ? 'Befejezés' : 'Következő',
            onNextPressed: goToNext,
            onPreviousPressed: goToPrevious,
            currentIndex: currentIndex,
            totalWorkouts: workouts.length,
        );
    }
}