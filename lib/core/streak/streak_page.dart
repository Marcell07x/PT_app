import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/core/streak/streak_manager.dart';
import 'package:getshap/core/streak/streak_calendar.dart';
import 'package:getshap/core/streak/streak_freeze_slot.dart';

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
    Set<int> _freezeDays = {};

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
            _lit = _streak > 0 && !(prefs.getBool('signal') ?? true);
            _loading = false;
        });
    }

    @override
    Widget build(BuildContext context) {
        final flameColor = _lit ? Colors.orange : Colors.black26;

        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: const Color.fromRGBO(22, 95, 239, 1),
                leading: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                ),
            ),
            body: _loading
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: Column(
                        children: [
                            const SizedBox(height: 24),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Icon(Icons.local_fire_department, color: flameColor, size: 64),
                                    const SizedBox(width: 8),
                                    Text(
                                        '$_streak',
                                        style: TextStyle(
                                            fontSize: 64,
                                            fontWeight: FontWeight.w900,
                                            color: flameColor,
                                        ),
                                    ),
                                ],
                            ),
                            Text(
                                AppLocalizations.of(context)!.workoutStreak,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: StreakCalendar(
                                    streak: _streak,
                                    startDate: _startDate,
                                    freezeDays: _freezeDays,
                                ),
                            ),
                            const Spacer(),
                            StreakFreezeSlot(hasFreeze: _hasFreeze),
                            const SizedBox(height: 32),
                        ],
                    ),
                ),
        );
    }
}
