import 'package:flutter/material.dart';
import 'package:getshap/common/bokeh_background.dart';
import 'package:getshap/common/pressable_button.dart';
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                    // Title + options are vertically centred in the
                                    // free space; they scroll if they can't fit.
                                    Expanded(
                                        child: LayoutBuilder(
                                            builder: (context, constraints) => SingleChildScrollView(
                                                child: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        minHeight: constraints.maxHeight,
                                                    ),
                                                    child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                            Text(
                                                                widget.title,
                                                                textAlign: TextAlign.center,
                                                                style: const TextStyle(
                                                                    fontSize: 27,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                ),
                                                            ),
                                                            const SizedBox(height: 100),
                                                            for (final option in widget.options) ...[
                                                                _buildOption(option),
                                                                const SizedBox(height: 14),
                                                            ],
                                                        ],
                                                    ),
                                                ),
                                            ),
                                        ),
                                    ),
                                    const SizedBox(height: 12),
                                    Pressable3DButton(
                                        color: const Color(0xFF2E6BF0),
                                        height: 58,
                                        onPressed: _selected != null
                                            ? () => widget.onNext(context, _selected!)
                                            : null,
                                        child: Text(
                                            widget.nextLabel,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                            ),
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
            borderRadius: BorderRadius.circular(12),
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                decoration: BoxDecoration(
                    color: isSelected
                        ? const Color.fromRGBO(22, 95, 239, 1)
                        : const Color(0xFFDCDFE4),
                    borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                    option.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black87,
                    ),
                ),
            ),
        );
    }
}
