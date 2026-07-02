import 'package:flutter/material.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/core/streak/streak_increase.dart';

class CongratulationsScreen extends StatelessWidget {
    const CongratulationsScreen({super.key});
    static int workoutIsDone = 0;

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
                            StreakIncrease(),
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
                                    workoutIsDone = 1;
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