import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'workout_screen.dart';
import 'workout_done_screen.dart';
import 'workouta.dart';
import 'workouta_reps.dart';
import 'workoutb_home.dart';
import 'workoutb_reps.dart';
import 'legswitch.dart';
import 'level.dart';
import 'workout_signal.dart';
import 'workout_feedback.dart';

class WorkoutFlow extends StatefulWidget {
    @override
    _WorkoutFlowState createState() => _WorkoutFlowState();
}

class _WorkoutFlowState extends State<WorkoutFlow> {
    WorkoutA workouta = WorkoutA();
    WorkoutAReps workoutareps = WorkoutAReps();
    WorkoutBHome workoutBHome = WorkoutBHome();
    WorkoutBReps workoutBReps = WorkoutBReps();
    LegSwitch legSwitch = LegSwitch();
    WorkoutLevel workoutLevel = WorkoutLevel();

    final List<Map<String, String>> workouts = [];
    int currentIndex = 0;

    String getLocalizedExerciseName(String localizationKey, BuildContext context) {
        final loc = AppLocalizations.of(context)!;
        switch (localizationKey) {
            case 'wallPush': return loc.wallPush;
            case 'tablePush': return loc.tablePush;
            case 'kneePush': return loc.kneePush;
            case 'pushUp': return loc.pushUp;
            case 'declinePush': return loc.declinePush;
            case 'clapPush': return loc.clapPush;
            case 'archerPush': return loc.archerPush;
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
            case 'squat5': return loc.squat5;
            case 'lunge5': return loc.lunge5;
            case 'core1': return loc.core1;
            case 'core2': return loc.core2;
            default: return localizationKey;
        }
    }

    @override
    void initState() {
        super.initState();
        _initializeData();
    }

    void _initializeData() async {
        await workoutLevel.getLevel();
        if (workoutLevel.level < 150) {
            await workouta.SetExerA();
            await workoutareps.SetRepsA(workouta.workout_partsA);
            setState(() {
                workouts.addAll(workouta.workout_partsA);
            });
        }  else {
            await workoutBHome.SetExerBHome();
            await workoutBReps.SetRepsB(workoutBHome.workout_partsBHome);
            setState(() {
                workouts.addAll(workoutBHome.workout_partsBHome);
            });

        }   
    }

    void goToNext() {
        if (currentIndex < workouts.length - 1) {
            setState(() {
                currentIndex++;
            });
        }
    }

    Future<void> _toggleLegSwitch() async {
        await legSwitch.getSwitch();
        await legSwitch.setSwitch();
    }

    Future<void> _finishWorkout() async {
        final prefs = await SharedPreferences.getInstance();
        int levelF = prefs.getInt('level') ?? 1;

        await _toggleLegSwitch();
        await workoutLevel.setLevel();
        await WorkoutSignal.setSignalFalse();

        if (levelF > 149) {
            int workoutCount = prefs.getInt('workoutsThisWeek') ?? 0;
            workoutCount++;
            print('This is the workout count: ${workoutCount}');
            await prefs.setInt('workoutsThisWeek', workoutCount);
        }

        if (!mounted) return;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => WorkoutFeedback()),
        );
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
                appBar: AppBar(title: Text('Workout')),
                body: Center(child: Text('No Exercises Error')),
            );
        }

        final isLastWorkout = currentIndex == workouts.length - 1;
        final currentExercise = workouts[currentIndex];
        
        return WorkoutScreen(
            videoPath: currentExercise['videoPath']!,
            exerciseName: getLocalizedExerciseName(currentExercise['localizationKey']!, context),
            reps: "${currentExercise['reps']!} ${AppLocalizations.of(context)!.reps}",
            buttonText: isLastWorkout ? AppLocalizations.of(context)!.finish : AppLocalizations.of(context)!.next,
            onNextPressed: isLastWorkout ? _finishWorkout : goToNext,
            onPreviousPressed: goToPrevious,
            currentIndex: currentIndex,
            totalWorkouts: workouts.length,
        );
    }
}