import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

class TipItem {
    final String id;
    final String Function(BuildContext) getText;

    const TipItem(this.id, this.getText);
}

class TipsData {
    // List of TipItems pointing to the localization keys of the tips,
    // so we can get the localized string based on the BuildContext.

    static final List<TipItem> principles = [
        TipItem('principles1', (context) => AppLocalizations.of(context)!.principles1),
        TipItem('principles2', (context) => AppLocalizations.of(context)!.principles2),
        TipItem('principles3', (context) => AppLocalizations.of(context)!.principles3),
        TipItem('principles4', (context) => AppLocalizations.of(context)!.principles4),
    ];

    static final List<TipItem> beginnerWorkout = [
        TipItem('beginnerWorkout1', (context) => AppLocalizations.of(context)!.beginnerWorkout1),
        TipItem('beginnerWorkout2', (context) => AppLocalizations.of(context)!.beginnerWorkout2),
    ];

    static final List<TipItem> beginnerDiet = [
        TipItem('beginnerDiet1', (context) => AppLocalizations.of(context)!.beginnerDiet1),
        TipItem('beginnerDiet2', (context) => AppLocalizations.of(context)!.beginnerDiet2),
    ];

    static final List<TipItem> advancedWorkout = [
        TipItem('advancedWorkout1', (context) => AppLocalizations.of(context)!.advancedWorkout1),
        TipItem('advancedWorkout2', (context) => AppLocalizations.of(context)!.advancedWorkout2),
        TipItem('advancedWorkout3', (context) => AppLocalizations.of(context)!.advancedWorkout3),
        TipItem('advancedWorkout4', (context) => AppLocalizations.of(context)!.advancedWorkout4),
    ];

    static final List<TipItem> advancedDiet = [
        TipItem('advancedDiet1', (context) => AppLocalizations.of(context)!.advancedDiet1),
        TipItem('advancedDiet2', (context) => AppLocalizations.of(context)!.advancedDiet2),
        TipItem('advancedDiet3', (context) => AppLocalizations.of(context)!.advancedDiet3),
        TipItem('advancedDiet4', (context) => AppLocalizations.of(context)!.advancedDiet4),
        TipItem('advancedDiet5', (context) => AppLocalizations.of(context)!.advancedDiet5),
        TipItem('advancedDiet6', (context) => AppLocalizations.of(context)!.advancedDiet6),
    ];

    // A consolidated Map to make programmatic selection easier later
    static final Map<String, List<TipItem>> allCategories = {
        'principles': principles,
        'beginnerWorkout': beginnerWorkout,
        'beginnerDiet': beginnerDiet,
        'advancedWorkout': advancedWorkout,
        'advancedDiet': advancedDiet,
    };

    // Helper method to get a tip by its ID
    static TipItem? getTipById(String id) {
        for (var list in allCategories.values) {
            for (var tip in list) {
                if (tip.id == id) {
                    return tip;
                }
            }
        }
        return null;
    }
}
