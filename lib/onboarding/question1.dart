import 'package:flutter/material.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/onboarding/questionaire.dart';
import 'package:getshap/onboarding/question_template.dart';
import 'package:getshap/onboarding/question2.dart';

//this question is not being used for now
class Question1Page extends StatelessWidget {
    final QuestionnaireData data;
    const Question1Page({super.key, required this.data});

    @override
    Widget build(BuildContext context) {
        final l = AppLocalizations.of(context)!;
        return QuestionTemplate(
            progressLabel: '1/7',
            title: l.mainGoal,
            nextLabel: l.nextq,
            options: [
                QuestionOption(l.weightLoss, 'weight_loss'),
                QuestionOption(l.muscleBuild, 'muscle'),
            ],
            onNext: (ctx, value) {
                final v = value as String;
                prefs?.setString('main_goal', v);
                data.main_goal = v;
                Navigator.push(ctx,
                    MaterialPageRoute(builder: (_) => Question2Page(data: data)));
            },
        );
    }
}
