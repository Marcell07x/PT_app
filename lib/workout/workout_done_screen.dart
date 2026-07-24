import 'package:flutter/material.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/core/streak/streak_increase.dart';

class CongratulationsScreen extends StatelessWidget {
    const CongratulationsScreen({super.key});
    static int workoutIsDone = 0;

    @override
    Widget build(BuildContext context) {
        final l10n = AppLocalizations.of(context)!;

        return Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFFF3E0), Color(0xFFF6F7FB)],
                        stops: [0.0, 0.55],
                    ),
                ),
                child: SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                const SizedBox(height: 8),
                                Text(
                                    l10n.congrat,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF2E9E5B),
                                    ),
                                ),

                                Expanded(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            const StreakIncrease(),
                                            const SizedBox(height: 10),
                                            Text(
                                                l10n.workoutStreak.toUpperCase(),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 1.5,
                                                    color: Color(0xFF9A6A2E),
                                                ),
                                            ),
                                            const SizedBox(height: 30),
                                            Text(
                                                l10n.congratMessage,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.35,
                                                    color: Color(0xFF4A4F63),
                                                ),
                                            ),
                                        ],
                                    ),
                                ),

                                _PrimaryButton(
                                    label: l10n.finish,
                                    onPressed: () {
                                        workoutIsDone = 1;
                                        Navigator.popUntil(context, (route) => route.isFirst);
                                    },
                                ),
                            ],
                        ),
                    ),
                ),
            ),
        );
    }
}

/// Full-width call-to-action with a pressable 3D bottom edge.
class _PrimaryButton extends StatefulWidget {
    final String label;
    final VoidCallback onPressed;

    const _PrimaryButton({required this.label, required this.onPressed});

    @override
    State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
    bool _pressed = false;

    static const Color _base = Color(0xFF43A047);
    static const Color _edge = Color(0xFF2E7D32);

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapCancel: () => setState(() => _pressed = false),
            onTapUp: (_) {
                setState(() => _pressed = false);
                widget.onPressed();
            },
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 70),
                height: 58,
                transform: Matrix4.translationValues(0, _pressed ? 4 : 0, 0),
                decoration: BoxDecoration(
                    color: _base,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                        BoxShadow(
                            color: _edge,
                            offset: Offset(0, _pressed ? 0 : 4),
                            blurRadius: 0,
                        ),
                    ],
                ),
                alignment: Alignment.center,
                child: Text(
                    widget.label.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: Colors.white,
                    ),
                ),
            ),
        );
    }
}
