import 'package:flutter/material.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/onboarding/questionaire.dart';
import 'package:getshap/onboarding/question_template.dart';
import 'package:getshap/onboarding/question7.dart';

class Question6Page extends StatelessWidget {
    final QuestionnaireData data;
    const Question6Page({super.key, required this.data});

    @override
    Widget build(BuildContext context) {
        final l = AppLocalizations.of(context)!;
        return QuestionTemplate(
            progressLabel: '6/7',
            title: l.motivation,
            nextLabel: l.nextq,
            options: [
                QuestionOption(l.notAtAll, 0),
                QuestionOption(l.somewhat, 1),
                QuestionOption(l.motivated, 2),
            ],
            onNext: (ctx, value) {
                final v = value as int;
                prefs?.setInt('motivation', v);
                data.motivation = v;
                Navigator.push(ctx,
                    MaterialPageRoute(builder: (_) => Question7Page(data: data)));
            },
        );
    }
}
