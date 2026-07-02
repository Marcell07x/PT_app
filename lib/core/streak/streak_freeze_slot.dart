import 'package:flutter/material.dart';
import 'package:getshap/l10n/app_localizations.dart';

//goal: the freeze slot at the bottom of the streak page: a framed box
//      that shows the stored freeze (empty if there is none) + its name
class StreakFreezeSlot extends StatelessWidget {
    final bool hasFreeze;

    const StreakFreezeSlot({super.key, required this.hasFreeze});

    @override
    Widget build(BuildContext context) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                        color: hasFreeze ? const Color(0xFFE3F2FD) : Colors.transparent,
                        border: Border.all(
                            color: hasFreeze ? Colors.lightBlue : Colors.black26,
                            width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12),
                    ),
                    child: hasFreeze
                        ? const Icon(Icons.ac_unit, color: Colors.lightBlue, size: 36)
                        : null,
                ),
                const SizedBox(width: 16),
                Text(
                    AppLocalizations.of(context)!.streakFreeze,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                    ),
                ),
            ],
        );
    }
}
