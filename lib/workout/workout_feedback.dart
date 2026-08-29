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

    /// Emoji for the effort band. Changes in steps (like the original colour
    /// bands), staying positive — open-eyed smiles for the lighter levels and
    /// motivating icons for the hard end, never exhausted- or pained-looking.
    String _emojiForRPE(int value) {
        if (value <= 1) return '😌'; // very light — relaxed
        if (value <= 3) return '🙂'; // light
        if (value <= 6) return '😀'; // moderate — open-eyed smile
        if (value <= 8) return '💪'; // vigorous — gave it effort
        return '🔥'; // very intense — crushed it
    }

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
                                                            _EmojiBadge(color: effort, emoji: _emojiForRPE(rounded)),
                                                            const SizedBox(height: AppSpacing.xxl),
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                                                textBaseline: TextBaseline.alphabetic,
                                                                children: [
                                                                    Text(
                                                                        '$rounded',
                                                                        style: AppText.numeral(
                                                                            AppText.displaySmall,
                                                                        ).copyWith(color: effortInk),
                                                                    ),
                                                                    const SizedBox(width: AppSpacing.xs),
                                                                    Text(
                                                                        '/ 10',
                                                                        style: AppText.titleMedium.copyWith(color: AppColors.n400),
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
                                                SliderTheme(
                                                    data: SliderThemeData(
                                                        trackHeight: 10,
                                                        trackShape: const _GradientRpeTrackShape(),
                                                        thumbShape: const RoundSliderThumbShape(
                                                            enabledThumbRadius: 14,
                                                            elevation: 3,
                                                            pressedElevation: 6,
                                                        ),
                                                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                                                        thumbColor: AppColors.surface,
                                                        overlayColor: effort.withValues(alpha: 0.16),
                                                        showValueIndicator: ShowValueIndicator.never,
                                                    ),
                                                    child: Slider(
                                                        value: _rpeValue,
                                                        min: 1,
                                                        max: 10,
                                                        divisions: 9,
                                                        onChanged: (value) {
                                                            setState(() => _rpeValue = value);
                                                        },
                                                    ),
                                                ),
                                                const SizedBox(height: AppSpacing.xxs),
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

/// Glowing circular badge that shows the current effort emoji.
class _EmojiBadge extends StatelessWidget {
    final Color color;
    final String emoji;

    const _EmojiBadge({required this.color, required this.emoji});

    @override
    Widget build(BuildContext context) {
        return Container(
            width: 152,
            height: 152,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                boxShadow: [
                    BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 40, spreadRadius: 4),
                ],
                border: Border.all(color: color.withValues(alpha: 0.35), width: 3),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 76)),
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

/// Slider track painted with the full easy→hard gradient. The segment after the
/// thumb is replaced with a flat neutral so the current position reads as
/// progress.
class _GradientRpeTrackShape extends SliderTrackShape with BaseSliderTrackShape {
    const _GradientRpeTrackShape();

    @override
    void paint(
        PaintingContext context,
        Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required TextDirection textDirection,
        required Offset thumbCenter,
        Offset? secondaryOffset,
        bool isDiscrete = false,
        bool isEnabled = false,
        double additionalActiveTrackHeight = 2,
    }) {
        if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
            return;
        }

        final Rect trackRect = getPreferredRect(
            parentBox: parentBox,
            offset: offset,
            sliderTheme: sliderTheme,
            isEnabled: isEnabled,
            isDiscrete: isDiscrete,
        );

        final Radius radius = Radius.circular(trackRect.height / 2);
        final RRect rrect = RRect.fromRectAndRadius(trackRect, radius);
        final Canvas canvas = context.canvas;

        canvas.save();
        canvas.clipRRect(rrect);

        // Full spectrum gradient.
        final Paint gradientPaint = Paint()
            ..shader = LinearGradient(colors: AppColors.rpeBright).createShader(trackRect);
        canvas.drawRRect(rrect, gradientPaint);

        // The portion ahead of the thumb. This used to be a 62% white veil,
        // which worked when the card behind it was dark but vanishes on a white
        // one — the slider would have looked like it had no progress at all. An
        // opaque neutral also gives the white thumb something to sit against.
        final double thumbDx = thumbCenter.dx.clamp(trackRect.left, trackRect.right);
        final Rect inactiveRect = Rect.fromLTRB(
            thumbDx,
            trackRect.top,
            trackRect.right,
            trackRect.bottom,
        );
        canvas.drawRect(inactiveRect, Paint()..color = AppColors.n300);

        canvas.restore();
    }
}
