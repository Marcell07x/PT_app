import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Reusable full-bleed background: a flat base colour with soft, scattered
/// translucent circles ("bokeh") over it. Flat (no gradient), calm and unisex;
/// a warm accent element like the gold button pops strongly on it.
///
/// The scatter is deterministic (seeded) so it looks stable, and it is
/// RepaintBoundary-cached so it stays smooth during page transitions.
class BokehBackground extends StatelessWidget {
    final Widget child;

    /// Flat base fill.
    final Color baseColor;

    /// The two translucent circle tints.
    final Color circleColor1;
    final Color circleColor2;

    const BokehBackground({
        super.key,
        required this.child,
        this.baseColor = const Color(0xFF463B54),
        this.circleColor1 = const Color(0xFFEDE4D0),
        this.circleColor2 = const Color(0xFF6FA69B),
    });

    @override
    Widget build(BuildContext context) {
        return Stack(
            fit: StackFit.expand,
            children: [
                RepaintBoundary(
                    child: CustomPaint(
                        painter: _BokehPainter(
                            baseColor: baseColor,
                            c1: circleColor1,
                            c2: circleColor2,
                        ),
                        isComplex: true,
                        willChange: false,
                    ),
                ),
                child,
            ],
        );
    }
}

class _BokehPainter extends CustomPainter {
    final Color baseColor;
    final Color c1;
    final Color c2;

    _BokehPainter({required this.baseColor, required this.c1, required this.c2});

    @override
    void paint(Canvas canvas, Size size) {
        final Rect rect = Offset.zero & size;
        canvas.drawRect(rect, Paint()..color = baseColor);

        canvas.save();
        canvas.clipRect(rect);

        final math.Random rnd = math.Random(11);
        final int count =
            ((size.width * size.height) / 7000).round().clamp(24, 140);

        for (int i = 0; i < count; i++) {
            final double dx = rnd.nextDouble() * size.width;
            final double dy = rnd.nextDouble() * size.height;
            final double r = 12 + rnd.nextDouble() * 62;
            final bool teal = rnd.nextDouble() < 0.4;
            final Color base = teal ? c2 : c1;
            final double op = teal
                ? 0.10 + rnd.nextDouble() * 0.14
                : 0.07 + rnd.nextDouble() * 0.12;
            canvas.drawCircle(
                Offset(dx, dy),
                r,
                Paint()..color = base.withValues(alpha: op),
            );
        }

        canvas.restore();
    }

    @override
    bool shouldRepaint(covariant _BokehPainter old) {
        return old.baseColor != baseColor || old.c1 != c1 || old.c2 != c2;
    }
}
