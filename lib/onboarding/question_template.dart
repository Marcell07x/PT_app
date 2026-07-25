import 'package:flutter/material.dart';
import 'package:getshap/common/bokeh_background.dart';
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
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
                appBar: AppBar(
                    backgroundColor: const Color(0xFF2E6BF0),
                    foregroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    title: Text('${widget.progressLabel} ${AppLocalizations.of(context)!.question}'),
                ),
                body: BokehBackground(
                    child: SafeArea(
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                                children: [
                                    Text(
                                        widget.title,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                        ),
                                    ),
                                    const SizedBox(height: 20),
                                    for (final option in widget.options) ...[
                                        _buildOption(option),
                                        const SizedBox(height: 10),
                                    ],
                                    const SizedBox(height: 30),
                                    SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            onPressed: _selected != null
                                                ? () => widget.onNext(context, _selected!)
                                                : null,
                                            child: Text(widget.nextLabel),
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ),
                ),
            ),
        );
    }

    Widget _buildOption(QuestionOption option) {
        final bool isSelected = _selected == option.value;
        return InkWell(
            onTap: () => setState(() => _selected = option.value),
            borderRadius: BorderRadius.circular(8),
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: isSelected
                        ? const Color.fromRGBO(22, 95, 239, 1)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                    option.label,
                    style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                    ),
                ),
            ),
        );
    }
}
