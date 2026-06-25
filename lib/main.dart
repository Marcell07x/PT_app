import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'questionaire.dart';
import 'streak.dart';
import 'question1.dart';
import 'question2.dart';
import 'workout_flow.dart';
import 'warmup_flow.dart';
import 'level.dart';
import 'workout_signal.dart';
import 'schedule_noti.dart';
import 'checkdata.dart';
import 'questionaire.dart';
import 'no_workout_page.dart';
import 'workout_done_screen.dart';
import 'tip_detail_screen.dart';
import 'side_menu.dart';
import 'debug_buttons.dart';
import 'tip_manager.dart';
import 'tips_data.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await ScheduleNotifications.initNotification();
    await StreakManager.init(); 
    await WorkoutSignal.setSignalTrue();
    await prefsInit();
    bool hasData = await CheckData.checkData();
    if (hasData) {
        runApp(const MyApp());
    } else {
        final _qdata = QuestionnaireData();
        runApp(
            MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: Question2Page(data: _qdata),
                ),
            );
    }
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
            debugShowCheckedModeBanner: false,
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
    bool _isTipLoading = true;
    Color _tipBackgroundColor = Colors.white;

    @override
    void initState() {
        super.initState();
        _checkWorkout();
        WorkoutSignal.onSignalChanged = _checkWorkout;
        _initTipManager();
    }

    Future<void> _initTipManager() async {
        await TipManager().initialize();
        if (mounted) {
            setState(() {
                _isTipLoading = false;
                if (TipManager().isNewTipForSession) {
                    _tipBackgroundColor = const Color(0xFFFFF9C4); // pale yellow
                }
            });
        }
    }

    String _getTipText(BuildContext context) {
        final tipId = TipManager().currentTipId;
        if (tipId != null) {
            final tipItem = TipsData.getTipById(tipId);
            if (tipItem != null) {
                return tipItem.getText(context);
            }
        }
        return "...";
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
    
    late int workoutDone;
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: const Color.fromRGBO(22, 95, 239, 1),
                actions: [
                    Builder(
                        builder: (context) => IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () => Scaffold.of(context).openEndDrawer(),
                        ),
                    ),
                ],
            ),
            endDrawer: SideMenu(
                onSetLevelPressed: () => DebugButtonsLogic.handleSetLevelPressed(
                    context: context,
                    updateState: () => setState(() {}),
                    setWorkoutDone: (val) => workoutDone = val,
                ),
                onFormPressed: () => DebugButtonsLogic.handleFormPressed(context),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        const SizedBox(height: 30),
                        GestureDetector(
                            onTap: () {
                                if (_isTipLoading) return;
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => TipDetailScreen(tip: _getTipText(context)),
                                    ),
                                );
                            },
                            child: Container(
                                width: 280,
                                height: 140,
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                    color: _tipBackgroundColor,
                                    border: Border.all(
                                        color: const Color.fromRGBO(22, 95, 239, 1),
                                        width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                ),
                                child: _isTipLoading ? const Center(child: CircularProgressIndicator()) : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                            AppLocalizations.of(context)!.tip,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(22, 95, 239, 1),
                                                fontSize: 16,
                                            ),
                                        ),
                                        const SizedBox(height: 8),
                                        Expanded(
                                            child: Text(
                                                _getTipText(context),
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 14,
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                            onPressed: _isButtonEnabled ? () async {
                                await StreakManager.incrementStreak();
                                final prefs = await SharedPreferences.getInstance();
                                int wlevel = prefs.getInt('level') ?? 1;
                                //for testing, you should make the line below a comment
                                workoutDone = CongratulationsScreen.workoutIsDone;
                                setState(() {});
                                if (wlevel <= 129 && workoutDone == 0) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => WorkoutFlow(),
                                        ),
                                    );
                                } else if (workoutDone == 0 && wlevel > 129){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => WarmupFlow(),
                                        ),
                                    );
                                } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const NoWorkout()),
                                    );
                                }
                            } : null,   
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(22, 95, 239, 1),
                                minimumSize: const Size(280, 120),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                ),
                            ),
                            child: Text(
                                AppLocalizations.of(context)!.startWorkout,
                                style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}