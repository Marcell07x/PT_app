import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'workout_flow.dart';
import 'workout_screen.dart';
import 'level.dart';

class WarmupFlow extends StatefulWidget {
    const WarmupFlow({super.key});

    @override
    _WarmupFlowState createState() => _WarmupFlowState();
}

class _WarmupFlowState extends State<WarmupFlow> {
    WorkoutLevel workoutLevel = WorkoutLevel();

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
            default: return localizationKey;
        }
    }
        
}