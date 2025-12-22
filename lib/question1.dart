import 'package:flutter/material.dart';
import 'questionaire.dart';
import 'question2.dart';
import 'l10n/app_localizations.dart';

//if any data is missing, they shoud do the survey
class Question1Page extends StatefulWidget {
    @override
    _Question1PageState createState() => _Question1PageState();
}

class _Question1PageState extends State<Question1Page> {
    final _data = QuestionnaireData();
    String? _selected;

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
    
            home: Scaffold(
                appBar: AppBar(
                    title: Text('1. ' + AppLocalizations.of(context)!.question),
                    automaticallyImplyLeading: false,
                ),
                body: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                        children: [
                            Text(AppLocalizations.of(context)!.mainGoal,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            _buildOption(AppLocalizations.of(context)!.weightLoss, 'weight_loss'),
                            SizedBox(height: 10),
                            _buildOption(AppLocalizations.of(context)!.muscleBuild, 'muscle'),
                            SizedBox(height: 40),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: _selected != null
                                        ? () {
                                            prefs?.setString('main_goal', _selected!);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => Question2Page(data: _data)));
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

    Widget _buildOption(String text, String value) {
        return InkWell(
            onTap: () => setState(() {
                _selected = value;
                _data.main_goal = value;
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