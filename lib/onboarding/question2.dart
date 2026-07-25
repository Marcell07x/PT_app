import 'package:flutter/material.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/onboarding/questionaire.dart';
import 'package:getshap/onboarding/question_template.dart';
import 'package:getshap/onboarding/question3.dart';

class Question2Page extends StatelessWidget {
    final QuestionnaireData data;
    const Question2Page({super.key, required this.data});

    @override
    Widget build(BuildContext context) {
        final l = AppLocalizations.of(context)!;
        return QuestionTemplate(
            progressLabel: '2/7',
            title: l.maxKneePush,
            nextLabel: l.nextq,
            options: const [
                QuestionOption('0-15', 0),
                QuestionOption('15+', 1),
            ],
            onNext: (ctx, value) {
                final v = value as int;
                prefs?.setInt('knee_pushups', v);
                data.knee_pushups = v;
                Navigator.push(ctx,
                    MaterialPageRoute(builder: (_) => Question3Page(data: data)));
            },
        );
    }
}
