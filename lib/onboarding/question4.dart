import 'package:getshap/onboarding/questionaire.dart';
import 'package:flutter/material.dart';
import 'package:getshap/onboarding/question5.dart';
import 'package:getshap/l10n/app_localizations.dart';

class Question4Page extends StatefulWidget {
    final QuestionnaireData data;
    const Question4Page({super.key, required this.data});
    @override
    _Question4PageState createState() => _Question4PageState();
}

class _Question4PageState extends State<Question4Page> {
    bool? _selected;

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
                appBar: AppBar(title: Text('4/7 ${AppLocalizations.of(context)!.question}')),
                body: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                        children: [
                            Text( AppLocalizations.of(context)!.prevExp1,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            _buildOption( AppLocalizations.of(context)!.yes, true),
                            SizedBox(height: 10),
                            _buildOption( AppLocalizations.of(context)!.no, false),
                            SizedBox(height: 40),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: _selected != null
                                        ? () {
                                            prefs?.setBool('previous_exp_1', _selected!);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => Question5Page(data: widget.data)));
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

    Widget _buildOption(String text, bool value) {
        return InkWell(
            onTap: () => setState(() {
                _selected = value;
                widget.data.previous_exp_1 = value;
            }),
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: _selected == value ? Color.fromRGBO(22, 95, 239, 1) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                ),
                child: Text(text),
            ),
        );
    }
}