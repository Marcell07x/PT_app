import 'package:flutter/material.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/onboarding/questionaire.dart';
import 'package:getshap/onboarding/question_template.dart';
import 'package:getshap/onboarding/question6.dart';

class Question5Page extends StatelessWidget {
    final QuestionnaireData data;
    const Question5Page({super.key, required this.data});

    @override
    Widget build(BuildContext context) {
        final l = AppLocalizations.of(context)!;
        return QuestionTemplate(
            progressLabel: '5/7',
            title: l.prevExp2,
            nextLabel: l.nextq,
            options: [
                QuestionOption(l.yes, true),
                QuestionOption(l.no, false),
            ],
            onNext: (ctx, value) {
                final v = value as bool;
                prefs?.setBool('previous_exp_2', v);
                data.previous_exp_2 = v;
                Navigator.push(ctx,
                    MaterialPageRoute(builder: (_) => Question6Page(data: data)));
            },
        );
    }
}
