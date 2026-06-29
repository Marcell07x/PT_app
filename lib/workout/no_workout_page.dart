import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

//sometimes the Start Workout button doesn't get disabled, so we need this page

class NoWorkout extends StatelessWidget {
    const NoWorkout({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
                appBar: AppBar(
                    leading: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                            Navigator.pop(context);
                        },
                    ),
                    title: Text(
                        AppLocalizations.of(context)!.workout,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                        ),
                    ),
                    backgroundColor: Color.fromRGBO(22, 95, 239, 1),
                ),
                body: Center(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                            AppLocalizations.of(context)!.noWorkout,
                            style: const TextStyle(
                                fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                        ),
                    ),
                ),
            ),
        );
    }
}