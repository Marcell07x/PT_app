import 'package:flutter/material.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/onboarding/questionaire.dart';
import 'package:getshap/onboarding/question_template.dart';
import 'package:getshap/onboarding/questionaire_converter.dart';
import 'package:getshap/onboarding/finish_warning.dart';

class Question7Page extends StatelessWidget {
    final QuestionnaireData data;
    const Question7Page({super.key, required this.data});

    @override
    Widget build(BuildContext context) {
        final l = AppLocalizations.of(context)!;
        return QuestionTemplate(
            progressLabel: '7/7',
            title: l.age,
            nextLabel: l.finish,
            options: const [
                QuestionOption('< 30', 1),
                QuestionOption('30-60', 2),
                QuestionOption('60 +', 3),
            ],
            onNext: (ctx, value) async {
                final v = value as int;
                prefs?.setInt('age', v);
                data.age = v;
                await Converter().convert();
                if (!ctx.mounted) return;
                Navigator.of(ctx).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const FinishWarning()),
                    (route) => false,
                );
            },
        );
    }
}
