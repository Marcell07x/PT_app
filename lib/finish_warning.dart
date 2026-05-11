import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'request_noti_permission.dart';

class FinishWarning extends StatelessWidget {
    const FinishWarning({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.blue,
                    title: Text(
                      AppLocalizations.of(context)!.important,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                      ),
                    ),
                ),
                body: Center(
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.red,
                                width: 4.0,
                            ),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                            AppLocalizations.of(context)!.finishWarning,
                            style: TextStyle(fontSize: 18.0),
                        ),
                    ),
                ),
                bottomNavigationBar: SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                    ),
                                ),
                                onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const RequestNotiPermission()),
                                    );
                                },
                                child: Text(AppLocalizations.of(context)!.understand),
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
}