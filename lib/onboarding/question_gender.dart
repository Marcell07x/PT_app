import 'package:flutter/material.dart';
import 'package:getshap/onboarding/questionaire.dart';
import 'package:getshap/onboarding/question2.dart';
import 'package:getshap/l10n/app_localizations.dart';

class QuestionGenderPage extends StatefulWidget {
    final QuestionnaireData data;
    const QuestionGenderPage({super.key, required this.data});
    @override
    _QuestionGenderPageState createState() => _QuestionGenderPageState();
}

class _QuestionGenderPageState extends State<QuestionGenderPage> {
    String? _selected;

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
                appBar: AppBar(
                    title: Text('1/7 ${AppLocalizations.of(context)!.question}'),
                    automaticallyImplyLeading: false,
                ),
                body: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                        children: [
                            Text(AppLocalizations.of(context)!.genderQuestion,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            _buildOption(AppLocalizations.of(context)!.male, 'male'),
                            SizedBox(height: 10),
                            _buildOption(AppLocalizations.of(context)!.female, 'female'),
                            SizedBox(height: 40),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: _selected != null
                                        ? () {
                                            prefs?.setString('gender', _selected!);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => Question2Page(data: widget.data)));
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
                widget.data.gender = value;
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
