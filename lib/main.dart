import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getshap/common/pressable_button.dart';
import 'package:getshap/common/bokeh_background.dart';
import 'package:getshap/common/splash_screen.dart';
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
import 'package:getshap/core/debug_clock.dart';
import 'package:getshap/notifications/schedule_noti.dart';
import 'package:getshap/core/checkdata.dart';
import 'package:getshap/onboarding/questionaire.dart';
import 'package:getshap/workout/no_workout_page.dart';
import 'package:getshap/workout/workout_done_screen.dart';
import 'package:getshap/tips/tip_detail_screen.dart';
import 'package:getshap/common/side_menu.dart';
import 'package:getshap/common/rounded_3d_app_bar.dart';
import 'package:getshap/dev/debug_buttons.dart';
import 'package:getshap/tips/tip_manager.dart';
import 'package:getshap/tips/tips_data.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await ScheduleNotifications.initNotification();
    await DebugClock.load();
    await StreakManager.checkStreak();
    await WorkoutSignal.setSignalTrue();
    await prefsInit();
    bool hasData = await CheckData.checkData();
    runApp(MyApp(hasData: hasData));
}

class MyApp extends StatelessWidget {
    /// Whether the user already has saved data (skip onboarding after splash).
    final bool hasData;

    const MyApp({super.key, required this.hasData});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,

            home: SplashScreen(
                nextBuilder: (context) => hasData
                    ? const MyHomePage()
                    : QuestionGenderPage(data: QuestionnaireData()),
            ),
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
        // for a newer version: a background Play update on Android, or an App
        // Store prompt on iOS.
        WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) AppUpdater.checkForUpdate(context);
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
            // Matches the bokeh background base so the float gap around the
            // rounded app bar blends into the page seamlessly.
            backgroundColor: const Color(0xFF463B54),
            onEndDrawerChanged: (isOpen) {
                setState(() {
                    _isEndDrawerOpen = isOpen;
                    // Always reopen on the menu list, never the info page.
                    if (!isOpen) _showInfo = false;
                });
            },
            appBar: Rounded3DAppBar(
                backgroundColor: const Color(0xFF2E6BF0),
                title: StreakFlame(
                    //lit: there is a streak and no workout is waiting for today
                    streak: _streak,
                    lit: _streak > 0 && !_isButtonEnabled,
                    onTap: () {
                        // CupertinoPageRoute enables the interactive left-edge
                        // swipe-back-to-pop gesture on Android too (not just iOS),
                        // popping back to the home page.
                        Navigator.of(context).push(
                            CupertinoPageRoute(builder: (context) => const StreakPage()),
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
                onAdvanceDayPressed: () => DebugButtonsLogic.handleAdvanceDayPressed(
                    context: context,
                    refresh: _checkWorkout,
                ),
                onDumpStatePressed: () => DebugButtonsLogic.handleDumpStatePressed(context),
                onFormPressed: () => DebugButtonsLogic.handleFormPressed(context),
            ),
            body: BokehBackground(
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            // ---- Daily tip panel (nudged up a little; the
                            // button stays centred) ----
                            Transform.translate(
                                offset: const Offset(0, -40),
                                child: GestureDetector(
                                onTap: () {
                                    if (_isTipLoading) return;
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (context) => TipDetailScreen(tip: _getTipText(context)),
                                        ),
                                    );
                                },
                                child: Container(
                                    width: 300,
                                    // White tip panel raised out of a thick black
                                    // 3D frame: the frame shows on the sides and
                                    // (thicker) at the bottom, but not at the top
                                    // where the panel pops out of it.
                                    decoration: BoxDecoration(
                                        color: _tipBackgroundColor,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: const [
                                            BoxShadow(
                                                color: Color(0xFF241B33),
                                                offset: Offset(0, 7),
                                                spreadRadius: 7,
                                                blurRadius: 0,
                                            ),
                                        ],
                                    ),
                                    child: _isTipLoading
                                        ? const SizedBox(
                                            height: 150,
                                            child: Center(child: CircularProgressIndicator()),
                                        )
                                        : Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                                Padding(
                                                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                                                    child: Text(
                                                        AppLocalizations.of(context)!.tip.toUpperCase(),
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.w800,
                                                            color: Color(0xFF16408C),
                                                            fontSize: 16,
                                                            letterSpacing: 0.5,
                                                        ),
                                                    ),
                                                ),
                                                Container(height: 1, color: const Color(0x1A16408C)),
                                                Padding(
                                                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                                                    child: Text(
                                                        _getTipText(context),
                                                        maxLines: 4,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                            color: Color(0xFF3A3F52),
                                                            fontSize: 14,
                                                            height: 1.4,
                                                        ),
                                                    ),
                                                ),
                                            ],
                                        ),
                                ),
                            ),
                            ),
                            const SizedBox(height: 44),
                            // ---- Start-workout button (battle-button style) ----
                            Pressable3DButton(
                                width: 280,
                                height: 120,
                                borderRadius: 16,
                                depth: 7,
                                color: const Color(0xFFF5A623),
                                edgeColor: const Color(0xFFC0770A),
                                gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Color(0xFFFFD23F), Color(0xFFF5A623)],
                                ),
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
                                child: Text(
                                    AppLocalizations.of(context)!.startWorkout.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 27,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                        shadows: [
                                            Shadow(
                                                color: Color(0x59000000),
                                                offset: Offset(0, 2),
                                                blurRadius: 2,
                                            ),
                                        ],
                                    ),
                                ),
                            ),
                        ],
                    ),
                ),
            ),
            ),
        );
    }
}