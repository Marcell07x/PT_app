import 'package:flutter/material.dart';

import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';

/// One tappable answer in the onboarding questionnaire.
///
/// Unselected it is a white card with a hairline border; selected it fills with
/// brand blue and the label goes white. The old version paired a hardcoded
/// `#DCDFE4` grey with the *other* brand blue, which is how the questionnaire
/// ended up showing two different blues on the same screen.
class AppOptionTile extends StatelessWidget {
    final String label;
    final bool selected;
    final VoidCallback onTap;

    const AppOptionTile({
        super.key,
        required this.label,
        required this.selected,
        required this.onTap,
    });

    @override
    Widget build(BuildContext context) {
        return Semantics(
            button: true,
            selected: selected,
            label: label,
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: onTap,
                    borderRadius: AppRadius.all(AppRadius.md),
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xxl,
                            horizontal: AppSpacing.xl,
                        ),
                        decoration: BoxDecoration(
                            color: selected ? AppColors.brand500 : AppColors.surface,
                            borderRadius: AppRadius.all(AppRadius.md),
                            border: Border.all(
                                color: selected ? AppColors.brand500 : AppColors.n200,
                                width: 1.5,
                            ),
                            boxShadow: selected ? AppShadows.sm : null,
                        ),
                        child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: AppText.titleMedium.copyWith(
                                color: selected ? AppColors.onBrand : AppColors.n900,
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
}
