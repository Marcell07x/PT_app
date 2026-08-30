import 'package:flutter/material.dart';

import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';

//goal: the flame icon + streak number unit shown in the AppBar,
//      tapping it opens the streak page
//      lit = there is a streak and no workout is waiting for today
//
// The bar behind it is now the light page rather than a blue slab, so the unit
// is drawn as a small white pill: it reads as a tappable object on a page that
// has no other chrome, and it gives the count somewhere to sit. Lit, the flame
// keeps its warm gradient; unlit it is a quiet outline in [AppColors.n400].
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
        return Semantics(
            button: true,
            value: '$streak',
            child: Material(
                color: AppColors.surface,
                shape: const StadiumBorder(
                    side: BorderSide(color: AppColors.n200),
                ),
                elevation: 0,
                child: InkWell(
                    onTap: onTap,
                    customBorder: const StadiumBorder(),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            AppSpacing.sm,
                            AppSpacing.lg,
                            AppSpacing.sm,
                        ),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                if (lit)
                                    ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (Rect rect) => const LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: <Color>[
                                                AppColors.flameC,
                                                AppColors.flameB,
                                                AppColors.flameA,
                                            ],
                                        ).createShader(rect),
                                        child: const Icon(
                                            Icons.local_fire_department,
                                            // The mask's alpha source — not a colour choice.
                                            color: Colors.white,
                                            size: 26,
                                        ),
                                    )
                                else
                                    const Icon(
                                        Icons.local_fire_department_outlined,
                                        color: AppColors.n400,
                                        size: 26,
                                    ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                    '$streak',
                                    style: AppText.numeral(AppText.titleMedium).copyWith(
                                        color: lit ? AppColors.n900 : AppColors.n400,
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
