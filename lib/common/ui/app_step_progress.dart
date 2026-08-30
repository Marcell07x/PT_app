import 'package:flutter/material.dart';

import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';

/// A progress bar drawn as one segment per step.
///
/// Replaces [LinearProgressIndicator] in the workout and questionnaire flows.
/// A continuous bar answers "how far along am I, as a fraction". Mid-workout
/// the question is "how many exercises are left", and nine segments answer that
/// without the user doing arithmetic on a sliver of blue.
class AppStepProgress extends StatelessWidget {
    /// How many steps there are. One segment each.
    final int total;

    /// How many are behind the user, including the one on screen. Clamped into
    /// `0..total`, so a caller may pass `currentIndex + 1` directly.
    final int completed;

    final double height;
    final double gap;

    final Color? color;
    final Color? trackColor;

    const AppStepProgress({
        super.key,
        required this.total,
        required this.completed,
        this.height = 6,
        this.gap = AppSpacing.xs,
        this.color,
        this.trackColor,
    });

    @override
    Widget build(BuildContext context) {
        if (total <= 0) return const SizedBox.shrink();

        final int done = completed.clamp(0, total);
        final Color fill = color ?? AppColors.brand500;
        final Color track = trackColor ?? AppColors.n200;

        return Semantics(
            // The old LinearProgressIndicator announced a percentage; a step
            // count is what this actually means.
            value: '$done / $total',
            child: Row(
                children: <Widget>[
                    for (int i = 0; i < total; i++) ...<Widget>[
                        if (i > 0) SizedBox(width: gap),
                        Expanded(
                            child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                height: height,
                                decoration: BoxDecoration(
                                    color: i < done ? fill : track,
                                    borderRadius: BorderRadius.circular(height / 2),
                                ),
                            ),
                        ),
                    ],
                ],
            ),
        );
    }
}
