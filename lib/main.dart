import 'package:flutter/material.dart';
import 'questionaire.dart';
import 'button_status.dart';
import 'streak.dart';
import 'question1.dart';
import 'workout_flow.dart';
import 'l10n/app_localizations.dart';
import 'level.dart';
import 'manuallysetlevel.dart';


void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await StatusManager.loadStatus();
    await StreakManager.init(); 
    await prefsInit();
    runApp(const MyApp());
}

class MyApp extends StatefulWidget {
    const MyApp({super.key});

    @override
    State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,

            home: MyHomePage(),
        );
    }
}

class MyHomePage extends StatefulWidget {
    const MyHomePage({super.key});

    @override
    State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    @override
    void initState() {
        super.initState();
    }

    Future<void> _handleComplete() async {
        await StreakManager.incrementStreak();
        await StatusManager.resetStatus();
        setState(() {});
    }
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('${StreakManager.streak}'),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        ElevatedButton(
                            onPressed: () async {
                                int? newLevel = await ManuallySetLevel.showLevelInputDialog(context);
                                if (newLevel != null) {
                                    await ManuallySetLevel.saveLevelToPrefs(newLevel);
                                    ManuallySetLevel.showSuccess(context, 'Level set: $newLevel');
                                    setState(() {});
                                }
                            }, 
                            child: const Text('Set Level')
                        ),
                        ElevatedButton(
                            onPressed: () async {
                                _handleComplete();
                                await StatusManager.resetStatus();
                                setState(() {});
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => WorkoutFlow(),
                                    ),
                                );
                            },  
                            child: Text(AppLocalizations.of(context)!.startWorkout)
                        ),
                        TextButton(
                            onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => Question1Page(),
                                    ),
                                );
                            },
                            child: Text(AppLocalizations.of(context)!.form)
                        ),
                    ],
                )
            )
        );
    }
}