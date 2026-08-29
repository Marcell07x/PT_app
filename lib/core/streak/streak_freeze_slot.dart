import 'package:flutter/material.dart';

import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';

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
                        color: hasFreeze ? AppColors.freezeSubtle : AppColors.n100,
                        border: Border.all(
                            color: hasFreeze ? AppColors.freeze : AppColors.n300,
                            width: 2.0,
                        ),
                        borderRadius: AppRadius.all(AppRadius.md),
                    ),
                    child: Icon(
                        Icons.ac_unit,
                        color: hasFreeze ? AppColors.freeze : AppColors.n300,
                        size: 32,
                    ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Text(
                    AppLocalizations.of(context)!.streakFreeze,
                    style: AppText.titleMedium.copyWith(
                        color: hasFreeze ? AppColors.n900 : AppColors.n500,
                    ),
                ),
            ],
        );
    }
}
