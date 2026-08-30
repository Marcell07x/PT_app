import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getshap/common/ui/app_button.dart';
import 'package:getshap/common/ui/app_card.dart';
import 'package:getshap/common/ui/app_scaffold.dart';
import 'package:getshap/common/ui/app_top_bar.dart';
import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';
import 'package:getshap/common/splash_screen.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/theme/app_theme.dart';
import 'package:getshap/onboarding/questionaire.dart';
import 'package:getshap/onboarding/question_gender.dart';
import 'package:getshap/onboarding/consent_page.dart';
import 'package:getshap/core/legal.dart';
import 'package:getshap/workout/workout_flow.dart';
import 'package:getshap/warmup/warmup_flow.dart';
import 'package:getshap/core/workout_signal.dart';
import 'package:getshap/core/app_update.dart';
import 'package:getshap/core/streak/streak_manager.dart';
import 'package:getshap/core/streak/streak_flame.dart';
import 'package:getshap/core/streak/streak_page.dart';
import 'package:getshap/core/debug_clock.dart';
import 'package:getshap/notifications/schedule_noti.dart';
import 'package:getshap/core/checkdata.dart';
import 'package:getshap/core/prefs_migration.dart';
import 'package:getshap/workout/next_workout_page.dart';
import 'package:getshap/tips/tip_detail_screen.dart';
import 'package:getshap/common/side_menu.dart';
import 'package:getshap/dev/debug_buttons.dart';
import 'package:getshap/tips/tip_manager.dart';
import 'package:getshap/tips/tips_data.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // The baseline for the screens that have no AppBar to carry it (the
    // feedback page, the tip detail sheet). Every screen that does have one
    // reapplies the same style through AppBarTheme, so the navigation bar never
    // changes colour while the app is running.
    SystemChrome.setSystemUIOverlayStyle(AppTheme.systemBars);
    await ScheduleNotifications.initNotification();
    await DebugClock.load();
    await StreakManager.checkStreak();
    await WorkoutSignal.refreshSignal();
    await prefsInit();
    //rewrites stored prefs whose meaning changed; must run before anything
    //reads them
    await PrefsMigration.run();
    bool hasData = await CheckData.checkData();
    ConsentStatus consent = await Legal.status();
    runApp(MyApp(hasData: hasData, consent: consent));
}

class MyApp extends StatelessWidget {
    /// Whether the user already has saved data (skip onboarding after splash).
    final bool hasData;

    /// Whether the terms have been accepted, and whether the accepted version
    /// is still the current one.
    final ConsentStatus consent;

    const MyApp({super.key, required this.hasData, required this.consent});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,

            home: SplashScreen(nextBuilder: _firstScreen),
        );
    }

    /// The consent screen comes before everything else, for new and existing
    /// users alike.
    ///
    /// It sits ahead of the questionnaire rather than after it because the
    /// questionnaire is already use of the app: it asks how many knee push-ups
    /// and squats the user can do, and some people will try them to answer. The
    /// warning has to come before any of that, and the terms have to be
    /// accepted before the contract is concluded (Ptk. 6:78 §).
    ///
    /// Users who already have data never pass through the questionnaire, so
    /// they would otherwise never be asked at all — the same screen catches
    /// them here, and they cannot reach the home screen until they accept.
    ///
    /// The screen also comes back for anyone whose accepted version is no
    /// longer the current one, since an earlier acceptance does not cover
    /// materially changed terms.
    Widget _firstScreen(BuildContext context) {
        WidgetBuilder afterConsent = hasData
            ? (_) => const MyHomePage()
            : (_) => QuestionGenderPage(data: QuestionnaireData());

        if (consent == ConsentStatus.current) return afterConsent(context);

        return ConsentPage(
            nextBuilder: afterConsent,
            isUpdate: consent == ConsentStatus.outdated,
        );
    }
}

class MyHomePage extends StatefulWidget {
    const MyHomePage({super.key});

    @override
    State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    bool _canWorkoutToday = true;
    bool _isTipLoading = true;
    int _streak = 0;
    /// Whether the tip on screen is one the user has not seen this session.
    bool _isNewTip = false;

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    // Which page the side menu currently shows: the list itself, or one of its
    // sub-pages.
    SideMenuView _menuView = SideMenuView.menu;
    // Whether the end drawer (side menu) is currently open.
    bool _isEndDrawerOpen = false;

    // Handles the Android system back button while the side menu is open:
    // sub-page -> menu list -> close drawer (back to home).
    void _handleBack() {
        if (_menuView != SideMenuView.menu) {
            setState(() => _menuView = SideMenuView.menu);
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
                _isNewTip = TipManager().isNewTipForSession;
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

        final canTrain = await WorkoutSignal.canWorkoutToday();
        final prefs = await SharedPreferences.getInstance();
        final streakValue = prefs.getInt('streak') ?? 0;

        if (!mounted) return;
        setState(() {
           _canWorkoutToday = canTrain;
           _streak = streakValue;
        });
    }
    
    @override
    Widget build(BuildContext context) {
        final AppLocalizations loc = AppLocalizations.of(context)!;

        return PopScope(
            // When the drawer is open we intercept back to step through
            // info -> menu -> home instead of letting the app exit.
            canPop: !_isEndDrawerOpen,
            onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                _handleBack();
            },
            child: AppScaffold(
                scaffoldKey: _scaffoldKey,
                onEndDrawerChanged: (isOpen) {
                    setState(() {
                        _isEndDrawerOpen = isOpen;
                        // Always reopen on the menu list, never a sub-page.
                        if (!isOpen) _menuView = SideMenuView.menu;
                    });
                },
                appBar: AppTopBar(
                    title: StreakFlame(
                        //lit: there is a streak and no workout is waiting for today
                        streak: _streak,
                        lit: _streak > 0 && !_canWorkoutToday,
                        onTap: () {
                            // CupertinoPageRoute enables the interactive left-edge
                            // swipe-back-to-pop gesture on Android too (not just iOS),
                            // popping back to the home page.
                            Navigator.of(context).push(
                                CupertinoPageRoute<void>(
                                    builder: (context) => const StreakPage(),
                                ),
                            );
                        },
                    ),
                    actions: [
                        Builder(
                            builder: (context) => IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () => Scaffold.of(context).openEndDrawer(),
                            ),
                        ),
                    ],
                ),
                endDrawer: SideMenu(
                    view: _menuView,
                    onContactPressed: () =>
                        setState(() => _menuView = SideMenuView.contact),
                    onBackToMenuPressed: () =>
                        setState(() => _menuView = SideMenuView.menu),
                    onSetLevelPressed: () => DebugButtonsLogic.handleSetLevelPressed(
                        context: context,
                        updateState: () => setState(() {}),
                    ),
                    onAdvanceDayPressed: () => DebugButtonsLogic.handleAdvanceDayPressed(
                        context: context,
                        refresh: _checkWorkout,
                    ),
                    onDumpStatePressed: () => DebugButtonsLogic.handleDumpStatePressed(context),
                    onFormPressed: () => DebugButtonsLogic.handleFormPressed(context),
                ),
                // Weighted rather than centred-then-nudged: the tip sits in the
                // upper third, the call to action just below the middle, and
                // both stay put across screen sizes.
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                        const Spacer(flex: 3),
                        _buildTipCard(loc),
                        const SizedBox(height: AppSpacing.huge),
                        AppButton(
                            label: loc.startWorkout.toUpperCase(),
                            size: AppButtonSize.hero,
                            onPressed: _startWorkout,
                        ),
                        const Spacer(flex: 4),
                    ],
                ),
            ),
        );
    }

    Widget _buildTipCard(AppLocalizations loc) {
        return AppCard.section(
            eyebrow: loc.tip,
            // A tip the user has not seen this session gets a faint brand tint
            // instead of the old highlighter yellow.
            color: _isNewTip ? AppColors.brand50 : AppColors.surface,
            onTap: _isTipLoading
                ? null
                : () => Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                        builder: (context) =>
                            TipDetailScreen(tip: _getTipText(context)),
                    ),
                ),
            child: _isTipLoading
                ? const SizedBox(
                    height: 72,
                    child: Center(child: CircularProgressIndicator()),
                )
                // The tip is the only content on the home screen, so it gets the
                // room: titleLarge's size at body weight, rather than the
                // 15px bodyMedium it shared with metadata everywhere else.
                // `weight` keeps the variable font's axis in step — copyWith
                // (fontWeight:) would silently do nothing here.
                // Six lines, not four. At the old 15px, four lines held all but
                // two of the eighteen tips; at 20px they hold twelve, so a third
                // of them would end in an ellipsis the user has to tap through.
                // Six lines at the larger size restores the original fit — and
                // the home screen has the room, since the tip is all that is on
                // it.
                : Text(
                    _getTipText(context),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.weight(AppText.titleLarge, 400).copyWith(
                        color: AppColors.n900,
                        height: 1.45,
                    ),
                ),
        );
    }

    Future<void> _startWorkout() async {
        final prefs = await SharedPreferences.getInstance();
        int wlevel = prefs.getInt('level') ?? 1;
        //button never greys out: decide here whether today is a workout day,
        //else show the countdown
        final canTrain = await WorkoutSignal.canWorkoutToday();
        if (!mounted) return;
        setState(() {
            _canWorkoutToday = canTrain;
        });
        if (!canTrain) {
            // CupertinoPageRoute: same as the streak page, so the left-edge
            // swipe-back gesture works on Android too
            Navigator.of(context).push(
                CupertinoPageRoute<void>(builder: (context) => const NextWorkoutPage()),
            );
            return;
        }
        Navigator.of(context).push(
            MaterialPageRoute<void>(
                builder: (context) => wlevel <= 129 ? WorkoutFlow() : WarmupFlow(),
            ),
        );
    }
}
