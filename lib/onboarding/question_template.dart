import 'package:flutter/material.dart';
import 'package:getshap/common/ui/app_button.dart';
import 'package:getshap/common/ui/app_option_tile.dart';
import 'package:getshap/common/ui/app_scaffold.dart';
import 'package:getshap/common/ui/app_step_progress.dart';
import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';
import 'package:getshap/l10n/app_localizations.dart';

/// One selectable answer: a display [label] and the [value] stored for it.
/// [value] can be any type (String / int / bool) — the screen casts it back
/// in its `onNext`.
class QuestionOption {
    final String label;
    final Object value;
    const QuestionOption(this.label, this.value);
}

/// Shared look and behaviour for every onboarding question. A question screen
/// is built just by constructing this template with its content plus an
/// [onNext] callback — no per-screen scaffolding, background or option styling
/// is duplicated anywhere else.
class QuestionTemplate extends StatefulWidget {
    /// Shown before the "question" word in the app bar, e.g. "2/7".
    final String progressLabel;

    /// Which question this is, 1-based, and how many there are. Drives the
    /// step bar under the app bar. Left null on a screen that is not part of a
    /// counted run (the gender question), which then shows no bar.
    final int? step;
    final int? stepCount;

    /// The question itself.
    final String title;

    /// The tappable answers.
    final List<QuestionOption> options;

    /// Label of the primary button (e.g. "Next" or "Finish").
    final String nextLabel;

    /// Called with the template's [BuildContext] and the chosen value when the
    /// user taps the primary button. Do the save + navigation here.
    final void Function(BuildContext context, Object value) onNext;

    const QuestionTemplate({
        super.key,
        required this.progressLabel,
        this.step,
        this.stepCount,
        required this.title,
        required this.options,
        required this.nextLabel,
        required this.onNext,
    });

    @override
    State<QuestionTemplate> createState() => _QuestionTemplateState();
}

class _QuestionTemplateState extends State<QuestionTemplate> {
    Object? _selected;

    @override
    Widget build(BuildContext context) {
        final AppLocalizations loc = AppLocalizations.of(context)!;

        return AppScaffold(
            title: '${widget.progressLabel} ${loc.question}',
            bottomBar: AppButton(
                label: widget.nextLabel,
                onPressed: _selected != null
                    ? () => widget.onNext(context, _selected!)
                    : null,
            ),
            // Title + options are vertically centred in the free space; they
            // scroll if they cannot fit (small screens, large system font).
            centerScrollable: true,
            body: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    if (widget.step != null && widget.stepCount != null) ...[
                        AppStepProgress(
                            total: widget.stepCount!,
                            completed: widget.step!,
                        ),
                        const SizedBox(height: AppSpacing.giant),
                    ],
                    Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: AppText.headlineMedium.copyWith(color: AppColors.n900),
                    ),
                    const SizedBox(height: AppSpacing.giant),
                    for (final option in widget.options) ...[
                        AppOptionTile(
                            label: option.label,
                            selected: _selected == option.value,
                            onTap: () => setState(() => _selected = option.value),
                        ),
                        const SizedBox(height: AppSpacing.md),
                    ],
                ],
            ),
        );
    }
}
