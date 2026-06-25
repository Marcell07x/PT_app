import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

class TipDetailScreen extends StatelessWidget {
    final String tip;
    const TipDetailScreen({super.key, required this.tip});
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.tip),
                backgroundColor: const Color.fromRGBO(22, 95, 239, 1),
            ),
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        tip,
                        style: const TextStyle(fontSize: 18, height: 1.5),
                    ),
                ),
            ),
        );
    }
}
