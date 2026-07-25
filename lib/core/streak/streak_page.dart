import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/core/streak/streak_manager.dart';
import 'package:getshap/core/streak/streak_calendar.dart';
import 'package:getshap/core/streak/streak_freeze_slot.dart';
import 'package:getshap/common/bokeh_background.dart';
import 'package:getshap/common/outlined_text.dart';

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
        final flameColor = _lit ? Colors.orange : const Color(0xFF8B93A1);

        return GestureDetector(
            // Swipe left-to-right from anywhere on the page (not just the very
            // left edge) to pop back to the home page.
            onHorizontalDragEnd: (details) {
                if ((details.primaryVelocity ?? 0) > 250) {
                    Navigator.of(context).pop();
                }
            },
            child: Scaffold(
            backgroundColor: const Color(0xFF463B54),
            appBar: AppBar(
                backgroundColor: flameColor,
                leading: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                ),
            ),
            body: BokehBackground(
                child: _loading
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: Column(
                        children: [
                            const SizedBox(height: 24),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Container(
                                        decoration: _lit
                                            ? const BoxDecoration(
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                    BoxShadow(
                                                        color: Color(0x80FF9800),
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
                                                        Color(0xFFFFD54F),
                                                        Color(0xFFFF9800),
                                                        Color(0xFFF4511E),
                                                    ],
                                                ).createShader(rect),
                                                child: const Icon(
                                                    Icons.local_fire_department,
                                                    color: Colors.white,
                                                    size: 84,
                                                ),
                                            )
                                            : Icon(
                                                Icons.local_fire_department,
                                                color: flameColor,
                                                size: 84,
                                            ),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedText(
                                        '$_streak',
                                        fontSize: 84,
                                        fontWeight: FontWeight.w900,
                                        color: flameColor,
                                        outlineWidth: 4.5,
                                    ),
                                ],
                            ),
                            OutlinedText(
                                AppLocalizations.of(context)!.workoutStreak,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(0.25),
                                            blurRadius: 16,
                                            offset: const Offset(0, 8),
                                        ),
                                    ],
                                ),
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
                            const SizedBox(height: 32),
                        ],
                    ),
                ),
            ),
        ),
        );
    }
}
