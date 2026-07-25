import 'package:flutter/material.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/onboarding/questionaire.dart';
import 'package:getshap/onboarding/question_template.dart';
import 'package:getshap/onboarding/question4.dart';

class Question3Page extends StatelessWidget {
    final QuestionnaireData data;
    const Question3Page({super.key, required this.data});

    @override
    Widget build(BuildContext context) {
        final l = AppLocalizations.of(context)!;
        return QuestionTemplate(
            progressLabel: '3/7',
            title: l.maxSquats,
            nextLabel: l.nextq,
            options: const [
                QuestionOption('< 10', 0),
                QuestionOption('10-20', 1),
                QuestionOption('20+', 2),
            ],
            onNext: (ctx, value) {
                final v = value as int;
                prefs?.setInt('bw_squats', v);
                data.bw_squats = v;
                Navigator.push(ctx,
                    MaterialPageRoute(builder: (_) => Question4Page(data: data)));
            },
        );
    }
}
