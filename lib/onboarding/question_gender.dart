import 'package:flutter/material.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/onboarding/questionaire.dart';
import 'package:getshap/onboarding/question_template.dart';
import 'package:getshap/onboarding/question2.dart';

class QuestionGenderPage extends StatelessWidget {
    final QuestionnaireData data;
    const QuestionGenderPage({super.key, required this.data});

    @override
    Widget build(BuildContext context) {
        final l = AppLocalizations.of(context)!;
        return QuestionTemplate(
            progressLabel: '1/7',
            title: l.genderQuestion,
            nextLabel: l.nextq,
            options: [
                QuestionOption(l.male, 'male'),
                QuestionOption(l.female, 'female'),
            ],
            onNext: (ctx, value) {
                final v = value as String;
                prefs?.setString('gender', v);
                data.gender = v;
                Navigator.push(ctx,
                    MaterialPageRoute(builder: (_) => Question2Page(data: data)));
            },
        );
    }
}
