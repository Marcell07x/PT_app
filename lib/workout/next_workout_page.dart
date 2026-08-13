import 'package:flutter/material.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/core/workout_signal.dart';

// Shown instead of starting a workout when today is a rest day: tells the user,
// rounded up to whole days, how many days until they can next train.
class NextWorkoutPage extends StatelessWidget {
    const NextWorkoutPage({super.key});

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            // Swipe left-to-right from anywhere on the page (not just the very
            // left edge) to pop back to the home page.
            onHorizontalDragEnd: (details) {
                if ((details.primaryVelocity ?? 0) > 250) {
                    Navigator.of(context).pop();
                }
            },
            child: Scaffold(
                appBar: AppBar(
                    leading: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                    ),
                    title: Text(
                        AppLocalizations.of(context)!.nextWorkoutTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                        ),
                    ),
                    backgroundColor: const Color.fromRGBO(22, 95, 239, 1),
                ),
                body: FutureBuilder<int>(
                    future: WorkoutSignal.daysUntilNextWorkout(),
                    builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                        }
                        final loc = AppLocalizations.of(context)!;
                        final days = snapshot.data!;
                        final String message;
                        if (days <= 0) {
                            // already trainable (e.g. finished this session) -> old copy
                            message = loc.noWorkout;
                        } else if (days == 1) {
                            message = loc.nextWorkoutTomorrow;
                        } else {
                            message = loc.nextWorkoutDays(days);
                        }
                        return Center(
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(
                                    message,
                                    style: const TextStyle(fontSize: 24),
                                    textAlign: TextAlign.center,
                                ),
                            ),
                        );
                    },
                ),
            ),
        );
    }
}
