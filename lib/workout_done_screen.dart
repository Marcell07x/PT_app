import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

class CongratulationsScreen extends StatelessWidget {
  const CongratulationsScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
            ),
            body: Center(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Icon(
                                Icons.celebration,
                                size: 100,
                                color: Colors.green,
                            ),
                            SizedBox(height: 30),
                            Text(
                                AppLocalizations.of(context)!.congrat,
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                ),
                            ),
                            SizedBox(height: 20),
                            Text(
                                AppLocalizations.of(context)!.congratMessage,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 40),
                            ElevatedButton(
                                onPressed: () {
                                    Navigator.popUntil(context, (route) => route.isFirst);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                ),
                                child: Text(
                                    AppLocalizations.of(context)!.finish,
                                    style: TextStyle(fontSize: 18),
                                ),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}