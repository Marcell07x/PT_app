import 'package:flutter/material.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/onboarding/questionaire.dart';
import 'package:getshap/onboarding/question_template.dart';
import 'package:getshap/onboarding/question5.dart';

class Question4Page extends StatelessWidget {
    final QuestionnaireData data;
    const Question4Page({super.key, required this.data});

    @override
    Widget build(BuildContext context) {
        final l = AppLocalizations.of(context)!;
        return QuestionTemplate(
            progressLabel: '4/7',
            title: l.prevExp1,
            nextLabel: l.nextq,
            options: [
                QuestionOption(l.yes, true),
                QuestionOption(l.no, false),
            ],
            onNext: (ctx, value) {
                final v = value as bool;
                prefs?.setBool('previous_exp_1', v);
                data.previous_exp_1 = v;
                Navigator.push(ctx,
                    MaterialPageRoute(builder: (_) => Question5Page(data: data)));
            },
        );
    }
}
