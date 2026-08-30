import 'package:flutter/material.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/workout/workout_flow.dart';
import 'package:getshap/common/ui/app_scaffold.dart';
import 'package:getshap/workout/workout_screen.dart';
import 'package:getshap/core/level.dart';
import 'package:getshap/warmup/warmup.dart';

class WarmupFlow extends StatefulWidget {
    const WarmupFlow({super.key});

    @override
    State<WarmupFlow> createState() => _WarmupFlowState();
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
            case 'reverseSnowAngel': return loc.reverseSnowAngel;
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
            case 'glute1': return loc.glute1;
            case 'glute2': return loc.glute2;
            case 'glute3': return loc.glute3;
            case 'glute4': return loc.glute4;
            case 'glute5': return loc.glute5;
            case 'core1': return loc.core1;
            case 'core2': return loc.core2;
            case 'lightBagPull': return loc.lightBagPull;
            case 'runInPlace': return loc.runInPlace;
            case 'wallPushDesc': return loc.wallPushDesc;
            case 'tablePushDesc': return loc.tablePushDesc;
            case 'kneePushDesc': return loc.kneePushDesc;
            case 'pushUpDesc': return loc.pushUpDesc;
            case 'declinePushDesc': return loc.declinePushDesc;
            case 'clapPushDesc': return loc.clapPushDesc;
            case 'archerPushDesc': return loc.archerPushDesc;
            case 'dipPushDesc': return loc.dipPushDesc;
            case 'bagPullDesc': return loc.bagPullDesc;
            case 'reverseSnowAngelDesc': return loc.reverseSnowAngelDesc;
            case 'bwPullDesc': return loc.bwPullDesc;
            case 'pullupDesc': return loc.pullupDesc;
            case 'squat1Desc': return loc.squat1Desc;
            case 'lunge1Desc': return loc.lunge1Desc;
            case 'squat2Desc': return loc.squat2Desc;
            case 'lunge2Desc': return loc.lunge2Desc;
            case 'squat3Desc': return loc.squat3Desc;
            case 'lunge3Desc': return loc.lunge3Desc;
            case 'squat4Desc': return loc.squat4Desc;
            case 'lunge4Desc': return loc.lunge4Desc;
            case 'squat5Desc': return loc.squat5Desc;
            case 'lunge5Desc': return loc.lunge5Desc;
            case 'glute1Desc': return loc.glute1Desc;
            case 'glute2Desc': return loc.glute2Desc;
            case 'glute3Desc': return loc.glute3Desc;
            case 'glute4Desc': return loc.glute4Desc;
            case 'glute5Desc': return loc.glute5Desc;
            case 'core1Desc': return loc.core1Desc;
            case 'core2Desc': return loc.core2Desc;
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
        Navigator.of(context).pushReplacement(
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
            // Transient: the warm-up is still being assembled. Was an
            // English-only "No Exercises Error" in a Hungarian/English app.
            return AppScaffold(
                title: AppLocalizations.of(context)!.warmup,
                showBack: false,
                body: const Center(child: CircularProgressIndicator()),
            );
        }

        final isLastWarmup = _currentIndex == warmupParts.length - 1;
        final currentExercise = warmupParts[_currentIndex];
        final isRunInPlace = currentExercise['nameKey'] == 'runInPlace';
        
        return WorkoutScreen(
            videoPath: currentExercise['videoPath']!,
            exerciseName: _getLocalizedExerciseName(currentExercise['nameKey']!, context),
            reps: isRunInPlace ? '20' : '12',
            repsLabel: isRunInPlace
                ? AppLocalizations.of(context)!.seconds
                : AppLocalizations.of(context)!.reps,
            description: isRunInPlace ? '' : AppLocalizations.of(context)!.warmupDesc,
            buttonText: AppLocalizations.of(context)!.next,
            label: AppLocalizations.of(context)!.warmup,
            onNextPressed: isLastWarmup ? _finishWarmup : _goToNext,
            onPreviousPressed: _goToPrevious,
            currentIndex: _currentIndex,
            totalWorkouts: warmupParts.length,
            level: 0,
        );
    }

}