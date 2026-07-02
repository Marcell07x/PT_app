import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//goal: the streak counting up on the workout done screen: a dim flame
//      with the old number that lights up, pops and switches to the
//      new (already saved) streak value
class StreakIncrease extends StatefulWidget {
    const StreakIncrease({super.key});

    @override
    State<StreakIncrease> createState() => _StreakIncreaseState();
}

class _StreakIncreaseState extends State<StreakIncrease> {
    int _shown = 0;
    bool _lit = false;
    bool _pop = false;

    @override
    void initState() {
        super.initState();
        _start();
    }

    Future<void> _start() async {
        final prefs = await SharedPreferences.getInstance();
        int streak = prefs.getInt('streak') ?? 0;

        if (!mounted) return;
        setState(() {
            _shown = streak > 0 ? streak - 1 : 0;
        });

        await Future.delayed(const Duration(milliseconds: 900));
        if (!mounted) return;
        setState(() {
            _shown = streak;
            _lit = true;
            _pop = true;
        });

        await Future.delayed(const Duration(milliseconds: 250));
        if (!mounted) return;
        setState(() {
            _pop = false;
        });
    }

    @override
    Widget build(BuildContext context) {
        final color = _lit ? Colors.orange : Colors.black26;

        return AnimatedScale(
            scale: _pop ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 250),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                            Icons.local_fire_department,
                            key: ValueKey(_lit),
                            color: color,
                            size: 90,
                        ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) => ScaleTransition(
                            scale: animation,
                            child: FadeTransition(opacity: animation, child: child),
                        ),
                        child: Text(
                            '$_shown',
                            key: ValueKey('$_shown-$_lit'),
                            style: TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.w900,
                                color: color,
                            ),
                        ),
                    ),
                ],
            ),
        );
    }
}
