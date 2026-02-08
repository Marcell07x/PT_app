import 'questionaire.dart';
import 'package:flutter/material.dart';
import "questionaire_converter.dart";
import "exercises.dart";
import 'l10n/app_localizations.dart';

class Question7Page extends StatefulWidget {
    final QuestionnaireData data;
    const Question7Page({Key? key, required this.data}) : super(key: key);
    @override
    _Question7PageState createState() => _Question7PageState();
}

class _Question7PageState extends State<Question7Page> {
    int? _selected;

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
                appBar: AppBar(title: Text('6. ' + AppLocalizations.of(context)!.question)),
                body: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                        children: [
                            Text(AppLocalizations.of(context)!.age,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            _buildOption('< 30', 1),
                            SizedBox(height: 10),
                            _buildOption('30-60', 2),
                            SizedBox(height: 10),
                            _buildOption('60 +', 3),
                            SizedBox(height: 40),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: _selected != null
                                        ? () async {
                                            prefs?.setInt('age', _selected!);
                                            Converter converter = Converter();
                                            await converter.convert();
                                            Navigator.of(context).popUntil((route) => route.isFirst);
                                        }
                                        : null,
                                    child: Text(AppLocalizations.of(context)!.finish),
                                ),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }

    Widget _buildOption(String text, int value) {
        return InkWell(
            onTap: () => setState(() {
                _selected = value;
                widget.data.age = value;
            }),
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: _selected == value ? Colors.blue : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                ),
                child: Text(text),
            ),
        );
    }
}