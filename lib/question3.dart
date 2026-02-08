import 'package:flutter/material.dart';
import 'questionaire.dart';
import 'question4.dart';
import 'l10n/app_localizations.dart';

class Question3Page extends StatefulWidget {
    final QuestionnaireData data;
    const Question3Page({Key? key, required this.data}) : super(key: key);
    @override
    _Question3PageState createState() => _Question3PageState();
}

class _Question3PageState extends State<Question3Page> {
    int? _selected;

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,

            home: Scaffold(
                appBar: AppBar(title: Text('2. ' + AppLocalizations.of(context)!.question)),
                body: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                        children: [
                            Text(AppLocalizations.of(context)!.maxSquats,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            _buildOption('< 10', 0),
                            SizedBox(height: 10),
                            _buildOption('10-20', 1),
                            SizedBox(height: 10),
                            _buildOption('20+', 2),
                            SizedBox(height: 40),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: _selected != null
                                        ? () {
                                            prefs?.setInt('bw_squats', _selected!);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => Question4Page(data: widget.data)));
                                        }
                                        : null,
                                    child: Text(AppLocalizations.of(context)!.nextq),
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
                widget.data.bw_squats = value;
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