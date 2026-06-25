import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

class TipsData {
    // List of functions pointing to the localization keys of the tips,
    // so we can get the localized string based on the BuildContext.

    static final List<String Function(BuildContext)> principles = [
        (context) => AppLocalizations.of(context)!.principles1,
        (context) => AppLocalizations.of(context)!.principles2,
        (context) => AppLocalizations.of(context)!.principles3,
    ];

    static final List<String Function(BuildContext)> beginnerWorkout = [
        (context) => AppLocalizations.of(context)!.beginnerWorkout1,
        (context) => AppLocalizations.of(context)!.beginnerWorkout2,
        (context) => AppLocalizations.of(context)!.beginnerWorkout3,
    ];

    static final List<String Function(BuildContext)> beginnerDiet = [
        (context) => AppLocalizations.of(context)!.beginnerDiet1,
        (context) => AppLocalizations.of(context)!.beginnerDiet2,
        (context) => AppLocalizations.of(context)!.beginnerDiet3,
    ];

    static final List<String Function(BuildContext)> advancedWorkout = [
        (context) => AppLocalizations.of(context)!.advancedWorkout1,
        (context) => AppLocalizations.of(context)!.advancedWorkout2,
        (context) => AppLocalizations.of(context)!.advancedWorkout3,
    ];

    static final List<String Function(BuildContext)> advancedDiet = [
        (context) => AppLocalizations.of(context)!.advancedDiet1,
        (context) => AppLocalizations.of(context)!.advancedDiet2,
        (context) => AppLocalizations.of(context)!.advancedDiet3,
    ];

    // A consolidated Map to make programmatic selection easier later
    static final Map<String, List<String Function(BuildContext)>> allCategories = {
        'principles': principles,
        'beginnerWorkout': beginnerWorkout,
        'beginnerDiet': beginnerDiet,
        'advancedWorkout': advancedWorkout,
        'advancedDiet': advancedDiet,
    };
}
