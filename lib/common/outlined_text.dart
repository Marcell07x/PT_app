import 'package:flutter/material.dart';

/// Text with a solid outline (stroke) drawn around the letters — the
/// Clash-Royale trick that keeps a label readable over ANY background, light
/// or dark, flat or patterned.
///
/// Use it for short labels, headings, numbers and buttons that sit directly on
/// a busy background. For long paragraphs prefer a panel/scrim behind the text
/// instead (outlining every letter of a paragraph looks heavy).
class OutlinedText extends StatelessWidget {
    final String text;
    final double fontSize;
    final FontWeight fontWeight;

    /// Letter fill colour.
    final Color color;

    /// Outline colour (kept dark so light text pops on any background).
    final Color outlineColor;

    /// Outline thickness.
    final double outlineWidth;

    final TextAlign textAlign;
    final double? letterSpacing;
    final double height;
    final int? maxLines;
    final TextOverflow? overflow;

    /// Optional soft shadow(s) drawn behind the text to lift it further off a
    /// busy background.
    final List<Shadow>? shadows;

    const OutlinedText(
        this.text, {
        super.key,
        this.fontSize = 18,
        this.fontWeight = FontWeight.w800,
        this.color = Colors.white,
        this.outlineColor = const Color(0xFF1A2233),
        this.outlineWidth = 3,
        this.textAlign = TextAlign.center,
        this.letterSpacing,
        this.height = 1.1,
        this.maxLines,
        this.overflow,
        this.shadows,
    });

    @override
    Widget build(BuildContext context) {
        final TextStyle base = TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
            height: height,
        );

        Widget layer(Paint? foreground, Color? fill, {List<Shadow>? shadow}) => Text(
            text,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
            style: base.copyWith(foreground: foreground, color: fill, shadows: shadow),
        );

        return Stack(
            children: [
                // Outline (+ optional shadow) underneath.
                layer(
                    Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = outlineWidth
                        ..strokeJoin = StrokeJoin.round
                        ..color = outlineColor,
                    null,
                    shadow: shadows,
                ),
                // Fill on top.
                layer(null, color),
            ],
        );
    }
}
