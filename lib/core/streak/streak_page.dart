import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/core/streak/streak_manager.dart';
import 'package:getshap/core/streak/streak_calendar.dart';
import 'package:getshap/core/streak/streak_freeze_slot.dart';
import 'package:getshap/common/ui/app_card.dart';
import 'package:getshap/common/ui/app_scaffold.dart';
import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';

//goal: the streak page: big streak number on top, the streak calendar
//      below it and the freeze slot at the bottom
class StreakPage extends StatefulWidget {
    const StreakPage({super.key});

    @override
    State<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends State<StreakPage> {
    bool _loading = true;
    int _streak = 0;
    bool _lit = false;
    bool _hasFreeze = false;
    int _startDate = 0;
    bool _todayPending = true;
    Set<int> _freezeDays = {};
    Set<int> _workoutDays = {};

    @override
    void initState() {
        super.initState();
        _loadData();
    }

    Future<void> _loadData() async {
        await StreakManager.checkStreak();
        final prefs = await SharedPreferences.getInstance();

        if (!mounted) return;
        setState(() {
            _streak = prefs.getInt('streak') ?? 0;
            _hasFreeze = (prefs.getInt('streakFreeze') ?? 0) == 1;
            _startDate = prefs.getInt('streakStartDate') ?? 0;
            _freezeDays = (prefs.getStringList('streakFreezeDays') ?? []).map(int.parse).toSet();
            _workoutDays = (prefs.getStringList('streakWorkoutDays') ?? []).map(int.parse).toSet();
            _todayPending = prefs.getBool('signal') ?? true;
            _lit = _streak > 0 && !_todayPending;
            _loading = false;
        });
    }

    @override
    Widget build(BuildContext context) {
        final AppLocalizations loc = AppLocalizations.of(context)!;

        return AppScaffold(
            title: loc.workoutStreak,
            swipeToPop: true,
            leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
            ),
            body: _loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                        const SizedBox(height: AppSpacing.xl),
                        _buildHero(loc),
                        const SizedBox(height: AppSpacing.xxl),
                        AppCard(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            shadow: AppShadows.md,
                            child: StreakCalendar(
                                streak: _streak,
                                startDate: _startDate,
                                freezeDays: _freezeDays,
                                workoutDays: _workoutDays,
                                todayPending: _todayPending,
                            ),
                        ),
                        const Spacer(),
                        StreakFreezeSlot(hasFreeze: _hasFreeze),
                        const SizedBox(height: AppSpacing.xxxl),
                    ],
                ),
        );
    }

    /// The flame and the count. The flame carries all the colour — lit it gets
    /// the warm gradient and a glow, unlit it is a quiet outline — while the
    /// number stays in the page's text colour so it is always readable.
    Widget _buildHero(AppLocalizations loc) {
        return Column(
            children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Container(
                            decoration: _lit
                                ? const BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                        BoxShadow(
                                            color: Color(0x59FF9800),
                                            blurRadius: 36,
                                            spreadRadius: -2,
                                        ),
                                    ],
                                )
                                : null,
                            child: _lit
                                ? ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (rect) => const LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                            AppColors.flameA,
                                            AppColors.flameB,
                                            AppColors.flameC,
                                        ],
                                    ).createShader(rect),
                                    child: const Icon(
                                        Icons.local_fire_department,
                                        // The mask's alpha source, not a colour choice.
                                        color: Colors.white,
                                        size: 84,
                                    ),
                                )
                                : const Icon(
                                    Icons.local_fire_department_outlined,
                                    color: AppColors.n400,
                                    size: 84,
                                ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                            '$_streak',
                            style: AppText.numeral(AppText.displayLarge).copyWith(
                                color: _lit ? AppColors.n900 : AppColors.n400,
                            ),
                        ),
                    ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                    loc.workoutStreak.toUpperCase(),
                    style: AppText.eyebrow.copyWith(color: AppColors.n500),
                ),
            ],
        );
    }
}
