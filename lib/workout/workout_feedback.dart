import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/workout/workout_done_screen.dart';
import 'package:getshap/workout/feedback_execution.dart';
import 'package:getshap/common/pressable_button.dart';

/// Brand blue used across the app.
const Color _kBrandBlue = Color.fromRGBO(22, 95, 239, 1);

/// Colour spectrum for the effort scale (easy -> hard). Shared between the
/// slider track painter and the value colour helper so they always match.
const List<Color> _kRpeSpectrum = [
    Color(0xFF22A45D), // green
    Color(0xFF7FBB3D), // lime
    Color(0xFFF2C230), // amber
    Color(0xFFF3831E), // orange
    Color(0xFFE23B3B), // red
];

class WorkoutFeedback extends StatefulWidget {
    const WorkoutFeedback({super.key});

    @override
    _WorkoutFeedbackState createState() => _WorkoutFeedbackState();
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

    /// Smoothly interpolated colour along [_kRpeSpectrum] for a 1..10 value.
    Color _colorForRPE(double value) {
        final double t = ((value - 1) / 9).clamp(0.0, 1.0);
        final double scaled = t * (_kRpeSpectrum.length - 1);
        final int i = scaled.floor().clamp(0, _kRpeSpectrum.length - 2);
        return Color.lerp(_kRpeSpectrum[i], _kRpeSpectrum[i + 1], scaled - i)!;
    }

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

    @override
    Widget build(BuildContext context) {
        final l10n = AppLocalizations.of(context)!;
        final int rounded = _rpeValue.round();
        final Color effort = _colorForRPE(_rpeValue);

        return PopScope(
            // Keep the user on the feedback screen until they tap Next.
            // Placed on the outer route so it blocks BOTH Android's hardware
            // back button and iOS's left-edge back-swipe.
            canPop: false,
            child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                                effort.withOpacity(0.16),
                                const Color(0xFFF6F7FB),
                            ],
                            stops: const [0.0, 0.5],
                        ),
                    ),
                    child: SafeArea(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                    // ---- Header -------------------------------------
                                    Text(
                                        l10n.feedback.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 2.0,
                                            color: Color(0xFF8A90A6),
                                        ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                        l10n.howWasTheWorkout,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w700,
                                            height: 1.15,
                                            color: Color(0xFFC4C9D4),
                                            shadows: [
                                                Shadow(
                                                    color: Color(0x33000000),
                                                    blurRadius: 8,
                                                    offset: Offset(0, 1),
                                                ),
                                            ],
                                        ),
                                    ),

                                    // ---- Hero: emoji + number + label ---------------
                                    Expanded(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                _EmojiBadge(color: effort, emoji: _emojiForRPE(rounded)),
                                                const SizedBox(height: 28),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                                    textBaseline: TextBaseline.alphabetic,
                                                    children: [
                                                        Text(
                                                            '$rounded',
                                                            style: TextStyle(
                                                                fontSize: 60,
                                                                fontWeight: FontWeight.w800,
                                                                height: 1.0,
                                                                color: effort,
                                                            ),
                                                        ),
                                                        const SizedBox(width: 4),
                                                        const Text(
                                                            '/ 10',
                                                            style: TextStyle(
                                                                fontSize: 22,
                                                                fontWeight: FontWeight.w600,
                                                                color: Color(0xFF9AA0B4),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                                const SizedBox(height: 14),
                                                _DescriptionChip(
                                                    color: effort,
                                                    text: _rpeDescriptions.isNotEmpty
                                                        ? _rpeDescriptions[rounded - 1]
                                                        : '',
                                                ),
                                            ],
                                        ),
                                    ),

                                    // ---- Slider card --------------------------------
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(24),
                                            boxShadow: [
                                                BoxShadow(
                                                    color: const Color(0xFF1E2233).withOpacity(0.06),
                                                    blurRadius: 24,
                                                    offset: const Offset(0, 8),
                                                ),
                                            ],
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
                                                        thumbColor: Colors.white,
                                                        overlayColor: effort.withOpacity(0.16),
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
                                                const SizedBox(height: 2),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        _ScaleEnd(number: '1', label: l10n.rpe1),
                                                        _ScaleEnd(
                                                            number: '10',
                                                            label: l10n.rpe910,
                                                            alignEnd: true,
                                                        ),
                                                    ],
                                                ),
                                            ],
                                        ),
                                    ),

                                    const SizedBox(height: 20),

                                    // ---- Continue button ----------------------------
                                    Pressable3DButton(
                                        color: _kBrandBlue,
                                        height: 56,
                                        width: double.infinity,
                                        onPressed: () async {
                                            final navigator = Navigator.of(context);
                                            final prefs = await SharedPreferences.getInstance();
                                            await prefs.setInt('rpe_value', _rpeValue.round());

                                            await FeedbackExecution.executeOnFeedback();

                                            if (!mounted) return;
                                            navigator.pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) => CongratulationsScreen(),
                                                ),
                                            );
                                        },
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                Text(
                                                    l10n.next,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                    ),
                                                ),
                                                const SizedBox(width: 8),
                                                const Icon(Icons.arrow_forward_rounded, size: 22, color: Colors.white),
                                            ],
                                        ),
                                    ),
                                ],
                            ),
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
                color: Colors.white,
                boxShadow: [
                    BoxShadow(
                        color: color.withOpacity(0.35),
                        blurRadius: 40,
                        spreadRadius: 4,
                    ),
                ],
                border: Border.all(color: color.withOpacity(0.35), width: 3),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 76)),
        );
    }
}

/// Rounded pill showing the textual effort description.
class _DescriptionChip extends StatelessWidget {
    final Color color;
    final String text;

    const _DescriptionChip({required this.color, required this.text});

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: color.withOpacity(0.14),
                borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color.lerp(color, Colors.black, 0.28),
                ),
            ),
        );
    }
}

/// Small end-of-scale marker beneath the slider (e.g. "1 · Very Light").
class _ScaleEnd extends StatelessWidget {
    final String number;
    final String label;
    final bool alignEnd;

    const _ScaleEnd({
        required this.number,
        required this.label,
        this.alignEnd = false,
    });

    @override
    Widget build(BuildContext context) {
        return Column(
            crossAxisAlignment:
                alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
                Text(
                    number,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF6B7186),
                    ),
                ),
                const SizedBox(height: 2),
                ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 110),
                    child: Text(
                        label,
                        textAlign: alignEnd ? TextAlign.end : TextAlign.start,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF9AA0B4),
                        ),
                    ),
                ),
            ],
        );
    }
}

/// Slider track painted with the full easy→hard gradient. The segment after the
/// thumb is dimmed so the current position still reads as progress.
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
            ..shader = const LinearGradient(colors: _kRpeSpectrum).createShader(trackRect);
        canvas.drawRRect(rrect, gradientPaint);

        // Dim the portion ahead of the thumb.
        final double thumbDx = thumbCenter.dx.clamp(trackRect.left, trackRect.right);
        final Rect inactiveRect = Rect.fromLTRB(
            thumbDx,
            trackRect.top,
            trackRect.right,
            trackRect.bottom,
        );
        canvas.drawRect(inactiveRect, Paint()..color = Colors.white.withOpacity(0.62));

        canvas.restore();
    }
}
