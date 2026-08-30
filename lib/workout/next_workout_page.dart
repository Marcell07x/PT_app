import 'package:flutter/material.dart';

import 'package:getshap/common/ui/app_scaffold.dart';
import 'package:getshap/core/workout_signal.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';

// Shown instead of starting a workout when today is a rest day: tells the user,
// rounded up to whole days, how many days until they can next train.
//
// The message used to sit inside an AppCard floating in the middle of an
// otherwise empty page, which is the one place a card does not help: there is
// nothing else on screen for it to be separated from. It is now a plain empty
// state — the page itself is the card.
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
                        child: SingleChildScrollView(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                    Container(
                                        width: 132,
                                        height: 132,
                                        decoration: const BoxDecoration(
                                            color: AppColors.brand50,
                                            shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                            Icons.self_improvement_rounded,
                                            color: AppColors.brand500,
                                            size: 64,
                                        ),
                                    ),
                                    const SizedBox(height: AppSpacing.xxxl),
                                    Text(
                                        message,
                                        textAlign: TextAlign.center,
                                        style: AppText.headlineMedium.copyWith(
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
