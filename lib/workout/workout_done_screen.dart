import 'package:flutter/material.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/core/streak/streak_increase.dart';
import 'package:getshap/common/pressable_button.dart';
import 'package:getshap/common/bokeh_background.dart';
import 'package:getshap/common/outlined_text.dart';

class CongratulationsScreen extends StatelessWidget {
    const CongratulationsScreen({super.key});

    @override
    Widget build(BuildContext context) {
        final l10n = AppLocalizations.of(context)!;

        return Scaffold(
            backgroundColor: Colors.transparent,
            body: BokehBackground(
                child: SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                Expanded(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            OutlinedText(
                                                l10n.congrat,
                                                fontSize: 36,
                                                fontWeight: FontWeight.w800,
                                                color: const Color(0xFF3AD17A),
                                                outlineWidth: 5,
                                                shadows: const [
                                                    Shadow(
                                                        color: Colors.black54,
                                                        blurRadius: 10,
                                                        offset: Offset(0, 3),
                                                    ),
                                                ],
                                            ),
                                            const SizedBox(height: 20),
                                            const StreakIncrease(),
                                            const SizedBox(height: 10),
                                            OutlinedText(
                                                l10n.workoutStreak.toUpperCase(),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 1.5,
                                                color: const Color(0xFFF3C969),
                                            ),
                                            const SizedBox(height: 30),
                                            OutlinedText(
                                                l10n.congratMessage,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600,
                                                height: 1.35,
                                                color: Colors.white,
                                            ),
                                        ],
                                    ),
                                ),

                                Pressable3DButton(
                                    color: const Color(0xFF43A047),
                                    edgeColor: const Color(0xFF2E7D32),
                                    height: 58,
                                    onPressed: () {
                                        Navigator.popUntil(context, (route) => route.isFirst);
                                    },
                                    child: Text(
                                        l10n.finish.toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.5,
                                            color: Colors.white,
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
