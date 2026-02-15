import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'package:workmanager/workmanager.dart';
import 'questionaire.dart';
import 'streak.dart';
import 'question1.dart';
import 'question2.dart';
import 'workout_flow.dart';
import 'level.dart';
import 'manuallysetlevel.dart';
import 'workout_signal.dart';
import "background_scheduler.dart";
import 'schedule_noti.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ScheduleNotifications.initNotification();

  
  Workmanager().initialize(
    () => Workmanager().executeTask((task, inputData) async {
            await WorkoutSignal.setSignalTrue();
            ScheduleNotifications.initNotification();
            //notification functions go here
            return Future.value(true);
        }),
    isInDebugMode: true,
  );
  
  await StreakManager.init(); 
  await WorkoutSignal.setSignalTrue();
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
    late bool _isButtonEnabled;

    @override
    void initState() {
        super.initState();
        BackgroundScheduler.scheduleDailyAt5PM();
        _checkWorkout();
        WorkoutSignal.onSignalChanged = _checkWorkout;
    }
    
    @override
    void dispose() {
        WorkoutSignal.onSignalChanged = null;
        super.dispose();
    }

    Future<void> _checkWorkout() async {
         if (!mounted) return;

        final prefs = await SharedPreferences.getInstance();
        final boolValue = prefs.getBool('signal') ?? true;
        setState(() {
           _isButtonEnabled = boolValue;
        });
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
                                WorkoutSignal.debugSetSignalTrue();
                                //await prefs?.setInt('workoutsThisWeek', 0);
                                await ScheduleNotifications.testNoti();
                                setState(() {});
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
                            onPressed: _isButtonEnabled ? () async {
                                await StreakManager.incrementStreak();
                                final prefs = await SharedPreferences.getInstance();
                                int testlevel = prefs.getInt('level') ?? 67676767;
                                print('testlevel is: $testlevel');
                                setState(() {});
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => WorkoutFlow(),
                                    ),
                                );
                            } : null,  
                            child: Text(AppLocalizations.of(context)!.startWorkout)
                        ),
                        TextButton(
                            onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => Question2Page(data: QuestionnaireData()),
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