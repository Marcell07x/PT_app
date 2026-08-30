import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:getshap/common/ui/app_button.dart';
import 'package:getshap/common/ui/app_card.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';
import 'package:getshap/workout/feedback_execution.dart';
import 'package:getshap/workout/workout_done_screen.dart';

class WorkoutFeedback extends StatefulWidget {
    const WorkoutFeedback({super.key});

    @override
    State<WorkoutFeedback> createState() => _WorkoutFeedbackState();
}

class _WorkoutFeedbackState extends State<WorkoutFeedback> {
    double _rpeValue = 5.0;

    List<String> _rpeDescriptions = [];

    /// Interpolates along a five-stop spectrum for a 1..10 value.
    static Color _alongSpectrum(List<Color> spectrum, double value) {
        final double t = ((value - 1) / 9).clamp(0.0, 1.0);
        final double scaled = t * (spectrum.length - 1);
        final int i = scaled.floor().clamp(0, spectrum.length - 2);
        return Color.lerp(spectrum[i], spectrum[i + 1], scaled - i)!;
    }

    /// The saturated colour — for large areas: the badge glow, the chip fill,
    /// the page tint.
    Color _colorForRPE(double value) => _alongSpectrum(AppColors.rpeBright, value);

    /// The readable partner of [_colorForRPE], for anything made of text. The
    /// bright spectrum is far too light for that on a white page: at RPE 3 it
    /// measures 2.31:1, which fails even the large-text bar.
    Color _inkForRPE(double value) => _alongSpectrum(AppColors.rpeInk, value);

    @override
    void didChangeDependencies() {
        super.didChangeDependencies();
        final l10n = AppLocalizations.of(context)!;
        _rpeDescriptions = [
            l10n.rpe1,
            l10n.rpe23,
            l10n.rpe23,
            l10n.rpe46,
            l10n.rpe46,
            l10n.rpe46,
            l10n.rpe78,
            l10n.rpe78,
            l10n.rpe910,
            l10n.rpe910,
        ];
    }

    Future<void> _submit() async {
        final navigator = Navigator.of(context);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('rpe_value', _rpeValue.round());

        await FeedbackExecution.executeOnFeedback();

        if (!mounted) return;
        navigator.pushReplacement(
            MaterialPageRoute<void>(builder: (context) => const CongratulationsScreen()),
        );
    }

    @override
    Widget build(BuildContext context) {
        final l10n = AppLocalizations.of(context)!;
        final int rounded = _rpeValue.round();
        final Color effort = _colorForRPE(_rpeValue);
        final Color effortInk = _inkForRPE(_rpeValue);

        return PopScope(
            // Keep the user on the feedback screen until they tap Next.
            // Placed on the outer route so it blocks BOTH Android's hardware
            // back button and iOS's left-edge back-swipe.
            canPop: false,
            child: Scaffold(
                // Opaque: without the nested MaterialApp that used to sit here,
                // a transparent scaffold would let the previous route show
                // through during the incoming transition.
                backgroundColor: AppColors.pageBg,
                body: DecoratedBox(
                    // A faint wash of the chosen effort colour at the top, so
                    // the answer tints the whole page without ever getting near
                    // the text.
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [effort.withValues(alpha: 0.14), AppColors.pageBg],
                            stops: const [0.0, 0.5],
                        ),
                    ),
                    child: SafeArea(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                AppSpacing.xl,
                                AppSpacing.md,
                                AppSpacing.xl,
                                AppSpacing.xl,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                    // ---- Header -------------------------------------
                                    Text(
                                        l10n.feedback.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: AppText.eyebrow.copyWith(color: AppColors.n500),
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                        l10n.howWasTheWorkout,
                                        textAlign: TextAlign.center,
                                        style: AppText.headlineMedium.copyWith(color: AppColors.n900),
                                    ),

                                    // ---- Hero: emoji + number + label ---------------
                                    // Centred in the free space, but scrollable:
                                    // the badge and the numeral are fixed-size,
                                    // so at a large system font they otherwise
                                    // overflow the space the card and button
                                    // leave behind.
                                    Expanded(
                                        child: LayoutBuilder(
                                            builder: (context, constraints) => SingleChildScrollView(
                                                child: ConstrainedBox(
                                                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                                                    child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                            // The number is the answer, so the number is
                                                            // the hero. The emoji badge that used to sit
                                                            // above it was the largest thing on screen and
                                                            // said less than the figure underneath it —
                                                            // and an emoji renders differently on every
                                                            // device, which is a poor way to carry meaning.
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                                                textBaseline: TextBaseline.alphabetic,
                                                                children: [
                                                                    Text(
                                                                        '$rounded',
                                                                        style: AppText.numeral(
                                                                            AppText.displayMedium,
                                                                        ).copyWith(color: effortInk),
                                                                    ),
                                                                    const SizedBox(width: AppSpacing.xs),
                                                                    Text(
                                                                        '/ 10',
                                                                        style: AppText.titleLarge.copyWith(color: AppColors.n400),
                                                                    ),
                                                                ],
                                                            ),
                                                            const SizedBox(height: AppSpacing.lg),
                                                            _DescriptionChip(
                                                                color: effort,
                                                                ink: effortInk,
                                                                text: _rpeDescriptions.isNotEmpty
                                                                        ? _rpeDescriptions[rounded - 1]
                                                                        : '',
                                                            ),
                                                        ],
                                                    ),
                                                ),
                                            ),
                                        ),
                                    ),

                                    // ---- Slider card --------------------------------
                                    AppCard(
                                        radius: AppRadius.lg,
                                        shadow: AppShadows.md,
                                        padding: const EdgeInsets.fromLTRB(
                                            AppSpacing.xl,
                                            AppSpacing.lg,
                                            AppSpacing.xl,
                                            AppSpacing.md,
                                        ),
                                        child: Column(
                                            children: [
                                                // Ten bars rather than a slider: the value *is*
                                                // discrete (divisions: 9 on a 1–10 slider), and a
                                                // continuous gradient track hid that. Each step is
                                                // its own tap target, and the rising heights say
                                                // "harder to the right" without needing colour.
                                                _RpeScale(
                                                    value: _rpeValue,
                                                    ink: effortInk,
                                                    onChanged: (double value) {
                                                        setState(() => _rpeValue = value);
                                                    },
                                                ),
                                                const SizedBox(height: AppSpacing.md),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        _ScaleEnd(number: '1', label: l10n.rpe1),
                                                        _ScaleEnd(number: '10', label: l10n.rpe910, alignEnd: true),
                                                    ],
                                                ),
                                            ],
                                        ),
                                    ),

                                    const SizedBox(height: AppSpacing.xl),

                                    // ---- Continue button ----------------------------
                                    AppButton(
                                        label: l10n.next,
                                        size: AppButtonSize.md,
                                        trailingIcon: Icons.arrow_forward_rounded,
                                        onPressed: _submit,
                                    ),
                                ],
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
}

/// The 1–10 effort scale, drawn as ten bars and used as the input.
///
/// Replaces the gradient [Slider]. The value was always discrete — the old
/// slider had `divisions: 9` — but a continuous track invited dragging for a
/// precision the scale does not have. Here each step is its own tap target, the
/// bars rise left to right so the direction reads without colour, and the
/// selected one carries a ring in the readable ink of its own band.
class _RpeScale extends StatelessWidget {
    /// Current value, 1..10.
    final double value;

    /// The readable partner colour of the current value, for the ring.
    final Color ink;

    final ValueChanged<double> onChanged;

    const _RpeScale({
        required this.value,
        required this.ink,
        required this.onChanged,
    });

    static const int _steps = 10;
    static const double _shortest = 22;
    static const double _tallest = 60;
    static const double _gap = AppSpacing.sm;

    /// Two steps per spectrum stop, so the ten bars walk the five bands.
    static Color _bandFor(int step) => AppColors.rpeBright[
        ((step - 1) ~/ 2).clamp(0, AppColors.rpeBright.length - 1)
    ];

    void _pickAt(double dx, double width) {
        final int step = (dx / (width / _steps)).floor().clamp(0, _steps - 1) + 1;
        if (step != value.round()) onChanged(step.toDouble());
    }

    void _nudge(int by) {
        final int next = (value.round() + by).clamp(1, _steps);
        if (next != value.round()) onChanged(next.toDouble());
    }

    @override
    Widget build(BuildContext context) {
        final int current = value.round();

        return Semantics(
            slider: true,
            value: '$current',
            increasedValue: '${(current + 1).clamp(1, _steps)}',
            decreasedValue: '${(current - 1).clamp(1, _steps)}',
            onIncrease: () => _nudge(1),
            onDecrease: () => _nudge(-1),
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                    final double width = constraints.maxWidth;

                    return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (TapDownDetails d) =>
                            _pickAt(d.localPosition.dx, width),
                        onHorizontalDragUpdate: (DragUpdateDetails d) =>
                            _pickAt(d.localPosition.dx, width),
                        child: SizedBox(
                            // Comfortably past the 44px touch minimum even where
                            // the shortest bar is.
                            height: _tallest + AppSpacing.md,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                    for (int step = 1; step <= _steps; step++) ...<Widget>[
                                        if (step > 1) const SizedBox(width: _gap),
                                        Expanded(
                                            child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 140),
                                                curve: Curves.easeOut,
                                                height: _shortest +
                                                    (_tallest - _shortest) *
                                                        (step - 1) /
                                                        (_steps - 1),
                                                decoration: BoxDecoration(
                                                    color: step <= current
                                                        ? _bandFor(step)
                                                        : AppColors.n200,
                                                    borderRadius: AppRadius.all(AppRadius.xs),
                                                    // A ring on the chosen bar: the outer
                                                    // shadow paints first, the surface-coloured
                                                    // one covers its inner part, leaving a
                                                    // 2px halo.
                                                    boxShadow: step == current
                                                        ? <BoxShadow>[
                                                            BoxShadow(color: ink, spreadRadius: 4),
                                                            const BoxShadow(
                                                                color: AppColors.surface,
                                                                spreadRadius: 2,
                                                            ),
                                                        ]
                                                        : null,
                                                ),
                                            ),
                                        ),
                                    ],
                                ],
                            ),
                        ),
                    );
                },
            ),
        );
    }
}

/// Rounded pill showing the textual effort description: a wash of the bright
/// spectrum colour behind the readable ink version of the same hue.
class _DescriptionChip extends StatelessWidget {
    final Color color;
    final Color ink;
    final String text;

    const _DescriptionChip({required this.color, required this.ink, required this.text});

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: AppRadius.all(AppRadius.pill),
            ),
            child: Text(
                text,
                textAlign: TextAlign.center,
                style: AppText.titleMedium.copyWith(color: ink),
            ),
        );
    }
}

/// Small end-of-scale marker beneath the slider (e.g. "1 · Very Light").
class _ScaleEnd extends StatelessWidget {
    final String number;
    final String label;
    final bool alignEnd;

    const _ScaleEnd({required this.number, required this.label, this.alignEnd = false});

    @override
    Widget build(BuildContext context) {
        return Column(
            crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
                Text(number, style: AppText.labelLarge.copyWith(color: AppColors.n600)),
                const SizedBox(height: AppSpacing.xxs),
                ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 110),
                    child: Text(
                        label,
                        textAlign: alignEnd ? TextAlign.end : TextAlign.start,
                        style: AppText.bodySmall.copyWith(color: AppColors.n500),
                    ),
                ),
            ],
        );
    }
}
