import 'package:flutter/material.dart';

import 'package:getshap/common/ui/app_card.dart';
import 'package:getshap/common/ui/app_scaffold.dart';
import 'package:getshap/core/workout_signal.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';

// Shown instead of starting a workout when today is a rest day: tells the user,
// rounded up to whole days, how many days until they can next train.
class NextWorkoutPage extends StatelessWidget {
    const NextWorkoutPage({super.key});

    @override
    Widget build(BuildContext context) {
        final AppLocalizations loc = AppLocalizations.of(context)!;

        return AppScaffold(
            title: loc.nextWorkoutTitle,
            swipeToPop: true,
            leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
            ),
            body: FutureBuilder<int>(
                future: WorkoutSignal.daysUntilNextWorkout(),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                    }

                    final int days = snapshot.data!;
                    final String message = days <= 0
                        // Already trainable (e.g. finished this session).
                        ? loc.noWorkout
                        : days == 1
                            ? loc.nextWorkoutTomorrow
                            : loc.nextWorkoutDays(days);

                    return Center(
                        child: AppCard(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                    Container(
                                        width: 72,
                                        height: 72,
                                        decoration: const BoxDecoration(
                                            color: AppColors.brand50,
                                            shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                            Icons.self_improvement_rounded,
                                            color: AppColors.brand500,
                                            size: 38,
                                        ),
                                    ),
                                    const SizedBox(height: AppSpacing.xl),
                                    Text(
                                        message,
                                        textAlign: TextAlign.center,
                                        style: AppText.headlineSmall.copyWith(
                                            color: AppColors.n900,
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    );
                },
            ),
        );
    }
}
