import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Reusable full-bleed background with a Clash-Royale-style diamond "quilt"
/// pattern painted over a vertical gradient. Each diamond is drawn as a raised
/// 3D tile (lit highlight on its upper edges, shadow on its lower edges, with a
/// thin groove between tiles). Drop any screen's content in as [child].
///
/// Colours are configurable so the same widget can back a grey, blue, or any
/// other themed screen.
class CheckeredBackground extends StatelessWidget {
    final Widget child;

    /// Base gradient, top to bottom.
    final List<Color> gradientColors;

    /// Subtle face tints for the two alternating diamonds.
    final Color lightTile;
    final Color darkTile;

    /// Bevel colours: [highlight] on the upper edges, [shadow] on the lower
    /// edges of every tile — this is what makes the diamonds look raised.
    final Color highlight;
    final Color shadow;

    /// Side length of one (un-rotated) square cell; larger = bigger diamonds.
    final double cellSize;

    /// Thickness of the bevel edges.
    final double bevel;

    const CheckeredBackground({
        super.key,
        required this.child,
        this.gradientColors = const [Color(0xFFD8ECEA), Color(0xFF14403D)],
        this.lightTile = const Color(0x08FFFFFF), // white ~3%
        this.darkTile = const Color(0x0F000000), // black ~6%
        this.highlight = const Color(0x24FFFFFF), // white ~14%
        this.shadow = const Color(0x2E000000), // black ~18%
        this.cellSize = 42,
        this.bevel = 2,
    });

    @override
    Widget build(BuildContext context) {
        // The pattern is drawn once and isolated in a RepaintBoundary so it is
        // rasterised and simply translated during page transitions instead of
        // being repainted every frame (which caused slow/janky slide-ins).
        return Stack(
            fit: StackFit.expand,
            children: [
                RepaintBoundary(
                    child: CustomPaint(
                        painter: _CheckeredPainter(
                            gradientColors: gradientColors,
                            lightTile: lightTile,
                            darkTile: darkTile,
                            highlight: highlight,
                            shadow: shadow,
                            cellSize: cellSize,
                            bevel: bevel,
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

class _CheckeredPainter extends CustomPainter {
    final List<Color> gradientColors;
    final Color lightTile;
    final Color darkTile;
    final Color highlight;
    final Color shadow;
    final double cellSize;
    final double bevel;

    _CheckeredPainter({
        required this.gradientColors,
        required this.lightTile,
        required this.darkTile,
        required this.highlight,
        required this.shadow,
        required this.cellSize,
        required this.bevel,
    });

    @override
    void paint(Canvas canvas, Size size) {
        final Rect rect = Offset.zero & size;

        // Base gradient.
        canvas.drawRect(
            rect,
            Paint()
                ..shader = LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: gradientColors,
                ).createShader(rect),
        );

        // Diamond quilt = a checkerboard of raised tiles rotated 45 degrees.
        canvas.save();
        canvas.clipRect(rect);
        canvas.translate(size.width / 2, size.height / 2);
        canvas.rotate(math.pi / 4);

        final double reach =
            math.sqrt(size.width * size.width + size.height * size.height);
        final int n = (reach / cellSize).ceil() + 1;

        final Paint fillLight = Paint()..color = lightTile;
        final Paint fillDark = Paint()..color = darkTile;
        final Paint hl = Paint()
            ..color = highlight
            ..strokeWidth = bevel
            ..strokeCap = StrokeCap.square;
        final Paint sh = Paint()
            ..color = shadow
            ..strokeWidth = bevel
            ..strokeCap = StrokeCap.square;

        const double inset = 1.0; // groove between tiles

        for (int ix = -n; ix < n; ix++) {
            for (int iy = -n; iy < n; iy++) {
                final double left = ix * cellSize + inset;
                final double top = iy * cellSize + inset;
                final double right = (ix + 1) * cellSize - inset;
                final double bottom = (iy + 1) * cellSize - inset;

                canvas.drawRect(
                    Rect.fromLTRB(left, top, right, bottom),
                    (ix + iy).isEven ? fillLight : fillDark,
                );

                // Upper edges (top + left in rotated space) catch the light.
                canvas.drawLine(Offset(left, top), Offset(right, top), hl);
                canvas.drawLine(Offset(left, top), Offset(left, bottom), hl);
                // Lower edges (bottom + right) fall into shadow.
                canvas.drawLine(Offset(left, bottom), Offset(right, bottom), sh);
                canvas.drawLine(Offset(right, top), Offset(right, bottom), sh);
            }
        }

        canvas.restore();
    }

    @override
    bool shouldRepaint(covariant _CheckeredPainter old) {
        return old.cellSize != cellSize ||
            old.bevel != bevel ||
            old.lightTile != lightTile ||
            old.darkTile != darkTile ||
            old.highlight != highlight ||
            old.shadow != shadow ||
            !listEquals(old.gradientColors, gradientColors);
    }
}
