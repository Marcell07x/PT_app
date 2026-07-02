import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/onboarding/questionaire.dart';
import 'package:getshap/onboarding/question1.dart';
import 'package:getshap/onboarding/question_gender.dart';
import 'package:getshap/workout/workout_flow.dart';
import 'package:getshap/warmup/warmup_flow.dart';
import 'package:getshap/core/level.dart';
import 'package:getshap/core/workout_signal.dart';
import 'package:getshap/core/app_update.dart';
import 'package:getshap/core/streak/streak_manager.dart';
import 'package:getshap/core/streak/streak_flame.dart';
import 'package:getshap/core/streak/streak_page.dart';
import 'package:getshap/notifications/schedule_noti.dart';
import 'package:getshap/core/checkdata.dart';
import 'package:getshap/onboarding/questionaire.dart';
import 'package:getshap/workout/no_workout_page.dart';
import 'package:getshap/workout/workout_done_screen.dart';
import 'package:getshap/tips/tip_detail_screen.dart';
import 'package:getshap/common/side_menu.dart';
import 'package:getshap/dev/debug_buttons.dart';
import 'package:getshap/tips/tip_manager.dart';
import 'package:getshap/tips/tips_data.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await ScheduleNotifications.initNotification();
    await StreakManager.checkStreak();
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
                home: QuestionGenderPage(data: _qdata),
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
    bool _isButtonEnabled = true;
    bool _isTipLoading = true;
    int _streak = 0;
    Color _tipBackgroundColor = Colors.white;

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    // Whether the side menu currently shows the info page instead of the list.
    bool _showInfo = false;
    // Whether the end drawer (side menu) is currently open.
    bool _isEndDrawerOpen = false;

    // Handles the Android system back button while the side menu is open:
    // info page -> menu list -> close drawer (back to home).
    void _handleBack() {
        if (_showInfo) {
            setState(() => _showInfo = false);
        } else {
            _scaffoldKey.currentState?.closeEndDrawer();
        }
    }

    @override
    void initState() {
        super.initState();
        _checkWorkout();
        WorkoutSignal.onSignalChanged = _checkWorkout;
        _initTipManager();
        // After the first frame (so a Scaffold/ScaffoldMessenger exists), check
        // Google Play for a newer version and offer a background update.
        WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) AppUpdater.checkForFlexibleUpdate(context);
        });
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

        await StreakManager.checkStreak();

        final prefs = await SharedPreferences.getInstance();
        final boolValue = prefs.getBool('signal') ?? true;
        final streakValue = prefs.getInt('streak') ?? 0;

        if (!mounted) return;
        setState(() {
           _isButtonEnabled = boolValue;
           _streak = streakValue;
        });
    }
    
    late int workoutDone;
    
    @override
    Widget build(BuildContext context) {
        return PopScope(
            // When the drawer is open we intercept back to step through
            // info -> menu -> home instead of letting the app exit.
            canPop: !_isEndDrawerOpen,
            onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                _handleBack();
            },
            child: Scaffold(
            key: _scaffoldKey,
            onEndDrawerChanged: (isOpen) {
                setState(() {
                    _isEndDrawerOpen = isOpen;
                    // Always reopen on the menu list, never the info page.
                    if (!isOpen) _showInfo = false;
                });
            },
            appBar: AppBar(
                backgroundColor: const Color.fromRGBO(22, 95, 239, 1),
                title: StreakFlame(
                    //lit: there is a streak and no workout is waiting for today
                    streak: _streak,
                    lit: _streak > 0 && !_isButtonEnabled,
                    onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const StreakPage()),
                        );
                    },
                ),
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
                showInfo: _showInfo,
                onShowInfoPressed: () => setState(() => _showInfo = true),
                onBackToMenuPressed: () => setState(() => _showInfo = false),
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
            ),
        );
    }
}