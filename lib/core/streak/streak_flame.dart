import 'package:flutter/material.dart';

import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';

//goal: the flame icon + streak number unit shown in the AppBar,
//      tapping it opens the streak page
//      lit = there is a streak and no workout is waiting for today
//
// This sits on the blue app bar, so both states are drawn in white: lit is
// solid, unlit is the same white at 45%. The old unlit colour was
// `Colors.white38`, which is close to invisible.
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

    static const Color _dim = Color(0x73FFFFFF);

    @override
    Widget build(BuildContext context) {
        return InkWell(
            onTap: onTap,
            borderRadius: AppRadius.all(AppRadius.sm),
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                ),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        // Lit: the warm flame gradient, the one place warmth is
                        // allowed on the blue bar. Unlit: a quiet outline.
                        if (lit)
                            ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (Rect rect) => const LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: <Color>[
                                        AppColors.flameA,
                                        AppColors.flameB,
                                    ],
                                ).createShader(rect),
                                child: const Icon(
                                    Icons.local_fire_department,
                                    // The mask's alpha source — not a colour choice.
                                    color: Colors.white,
                                    size: 28,
                                ),
                            )
                        else
                            const Icon(
                                Icons.local_fire_department_outlined,
                                color: _dim,
                                size: 28,
                            ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                            '$streak',
                            style: AppText.numeral(AppText.titleLarge).copyWith(
                                color: lit ? AppColors.onBrand : _dim,
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}
