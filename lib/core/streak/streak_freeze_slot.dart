import 'package:flutter/material.dart';

import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';

//goal: the freeze slot at the bottom of the streak page: a framed box
//      that shows the stored freeze (empty if there is none) + its name
//
// The slot is a single box because a single freeze is all the app ever stores
// (`streakFreeze` in prefs is 0 or 1). That was invisible before: one empty
// square says nothing about whether a second one could ever appear beside it,
// so the count is now spelled out as "0 / 1" next to the name. A capacity
// reads the same in every language, which is why it is a numeral rather than a
// new string to translate.
class StreakFreezeSlot extends StatelessWidget {
    final bool hasFreeze;

    /// How many freezes can be banked at once. One, today — named rather than
    /// hardcoded into the label so the day it changes, this still tells the
    /// truth.
    static const int capacity = 1;

    const StreakFreezeSlot({super.key, required this.hasFreeze});

    @override
    Widget build(BuildContext context) {
        final AppLocalizations loc = AppLocalizations.of(context)!;
        final Color ink = hasFreeze ? AppColors.freeze : AppColors.n300;
        final int stored = hasFreeze ? 1 : 0;

        return Semantics(
            label: loc.streakFreeze,
            value: '$stored / $capacity',
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                            color: hasFreeze ? AppColors.freezeSubtle : AppColors.n100,
                            border: Border.all(color: ink, width: 2.0),
                            borderRadius: AppRadius.all(AppRadius.md),
                        ),
                        child: Icon(Icons.ac_unit, color: ink, size: 32),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                            Text(
                                loc.streakFreeze,
                                style: AppText.titleMedium.copyWith(
                                    color: hasFreeze ? AppColors.n900 : AppColors.n500,
                                ),
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                                '$stored / $capacity',
                                style: AppText.numeral(AppText.bodySmall).copyWith(
                                    color: AppColors.n500,
                                ),
                            ),
                        ],
                    ),
                ],
            ),
        );
    }
}
