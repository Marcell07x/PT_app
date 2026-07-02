import 'package:flutter/material.dart';

//goal: the flame icon + streak number unit shown in the AppBar,
//      tapping it opens the streak page
//      lit = there is a streak and no workout is waiting for today
class StreakFlame extends StatelessWidget {
    final int streak;
    final bool lit;
    final VoidCallback onTap;

    const StreakFlame({
        super.key,
        required this.streak,
        required this.lit,
        required this.onTap,
    });

    @override
    Widget build(BuildContext context) {
        return InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Icon(
                            Icons.local_fire_department,
                            color: lit ? Colors.orange : Colors.white38,
                            size: 28,
                        ),
                        const SizedBox(width: 4),
                        Text(
                            '$streak',
                            style: TextStyle(
                                color: lit ? Colors.white : Colors.white38,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}
