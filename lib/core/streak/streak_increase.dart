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

        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        setState(() {
            _shown = streak;
            _lit = true;
            _pop = true;
        });

        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        setState(() {
            _pop = false;
        });
    }

    // Warm gradient used for the lit flame and streak number.
    static const List<Color> _flameGradient = [
        Color(0xFFFFD54F), // amber
        Color(0xFFFF9800), // orange
        Color(0xFFF4511E), // deep orange
    ];

    @override
    Widget build(BuildContext context) {
        return AnimatedScale(
            scale: _pop ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    _flameBadge(),
                    const SizedBox(height: 14),
                    _streakNumber(),
                ],
            ),
        );
    }

    Widget _flameBadge() {
        return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: 190,
            height: 190,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Just a soft glow behind the flame — no solid disc/ring.
                gradient: _lit
                    ? const RadialGradient(
                        colors: [Color(0x80FF9800), Color(0x00FF9800)],
                        stops: [0.0, 0.72],
                    )
                    : null,
                boxShadow: _lit
                    ? const [
                        BoxShadow(
                            color: Color(0x40FF9800),
                            blurRadius: 40,
                            spreadRadius: -4,
                        ),
                    ]
                    : const [],
            ),
            alignment: Alignment.center,
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _lit
                    ? ShaderMask(
                        key: const ValueKey(true),
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (rect) => const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: _flameGradient,
                        ).createShader(rect),
                        child: const Icon(
                            Icons.local_fire_department,
                            color: Colors.white,
                            size: 118,
                        ),
                    )
                    : const Icon(
                        Icons.local_fire_department,
                        key: ValueKey(false),
                        color: Colors.black26,
                        size: 118,
                    ),
            ),
        );
    }

    Widget _streakNumber() {
        final Widget number = Text(
            '$_shown',
            key: ValueKey('$_shown-$_lit'),
            style: const TextStyle(
                fontSize: 94,
                fontWeight: FontWeight.w900,
                height: 1.0,
                color: Colors.white,
            ),
        );

        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
            ),
            child: _lit
                ? ShaderMask(
                    key: ValueKey('lit-$_shown'),
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (rect) => const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: _flameGradient,
                    ).createShader(rect),
                    child: number,
                )
                : Text(
                    '$_shown',
                    key: ValueKey('dim-$_shown'),
                    style: const TextStyle(
                        fontSize: 94,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                        color: Colors.black26,
                    ),
                ),
        );
    }
}
