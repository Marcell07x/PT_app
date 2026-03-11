import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'workout_flow.dart';
import 'workout_screen.dart';
import 'level.dart';
import 'warmup.dart';

class WarmupFlow extends StatefulWidget {
    const WarmupFlow({super.key});

    @override
    _WarmupFlowState createState() => _WarmupFlowState();
}

class _WarmupFlowState extends State<WarmupFlow> {
    WorkoutLevel workoutLevel = WorkoutLevel();
    Warmup warmup = Warmup();

    final List<Map<String, String>> warmupParts = [];
    int _currentIndex = 0;

    String _getLocalizedExerciseName(String localizationKey, BuildContext context) {
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
            case 'lightBagPull': return loc.lightBagPull;
            case 'testKey': return loc.testDescription;
            default: return localizationKey;
        }
    }

    @override
    void initState() {
        super.initState();
        _initializeData();
    }

    void _initializeData() async {
        await warmup.setWarmup();
        setState(() {
            warmupParts.addAll(warmup.warmup_parts);
        });
    }    

    void _goToNext() {
        if (_currentIndex < warmupParts.length - 1) {
            setState(() {
                _currentIndex++;
            });
        }
    }

    Future<void> _finishWarmup() async {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => WorkoutFlow()),
        );
    }

    void _goToPrevious() {
        if (_currentIndex > 0) {
            setState(() {
                _currentIndex--;
            });
        } else {
            Navigator.of(context).pop();
        }
    }


    @override
    Widget build(BuildContext context) {
        if (warmupParts.isEmpty) {
            return Scaffold(
                appBar: AppBar(title: Text('Workout')),
                body: Center(child: Text('No Exercises Error')),
            );
        }

        final isLastWarmup = _currentIndex == warmupParts.length - 1;
        final currentExercise = warmupParts[_currentIndex];
        
        return WorkoutScreen(
            videoPath: currentExercise['videoPath']!,
            exerciseName: _getLocalizedExerciseName(currentExercise['nameKey']!, context),
            reps: "12 ${AppLocalizations.of(context)!.reps}",
            description: AppLocalizations.of(context)!.warmupDesc,
            buttonText: isLastWarmup ? AppLocalizations.of(context)!.finish : AppLocalizations.of(context)!.next,
            onNextPressed: isLastWarmup ? _finishWarmup : _goToNext,
            onPreviousPressed: _goToPrevious,
            currentIndex: _currentIndex,
            totalWorkouts: warmupParts.length,
        );
    }

}