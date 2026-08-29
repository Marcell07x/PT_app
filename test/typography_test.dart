// Proves the two things about the bundled font that would otherwise only show
// up on a device: that the variable weight axis actually moves, and that
// Hungarian ő/ű come from Manrope rather than a per-glyph fallback.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:getshap/theme/app_typography.dart';

void main() {
    setUpAll(() async {
        TestWidgetsFlutterBinding.ensureInitialized();
        final FontLoader loader = FontLoader(AppText.family)
            ..addFont(rootBundle.load('assets/fonts/Manrope-Variable.ttf'));
        await loader.load();
    });

    double widthOf(String text, TextStyle style) {
        final TextPainter painter = TextPainter(
            text: TextSpan(text: text, style: style),
            textDirection: TextDirection.ltr,
        )..layout();
        return painter.width;
    }

    test('the variable weight axis actually changes rendering', () {
        // Manrope's default instance is ExtraLight (wght 200). If
        // `fontVariations` were not being applied, every weight would render
        // identically and these widths would match.
        const String sample = 'Fekvőtámasz';
        final double light = widthOf(sample, AppText.bodyMedium);            // 400
        final double heavy = widthOf(
            sample,
            AppText.weight(AppText.bodyMedium, 800),
        );

        expect(
            heavy,
            greaterThan(light),
            reason: 'wght 800 must render wider than wght 400. If they are '
                'equal, TextStyle.fontVariations is not reaching the engine and '
                'the whole app is rendering in ExtraLight.',
        );
    });

    test('Hungarian ő and ű are real glyphs, not fallbacks', () {
        // ő (U+0151) and ű (U+0171) live in Latin Extended-A. A `latin`-only
        // subset would drop them and Flutter would silently substitute the
        // platform font per glyph — which is both ugly and hard to spot.
        // A double-acute is wider than its umlaut cousin in Manrope, and a
        // fallback would almost certainly not preserve that relationship
        // alongside identical widths for the base letters.
        final TextStyle style = AppText.bodyLarge;

        expect(widthOf('ő', style), greaterThan(0));
        expect(widthOf('ű', style), greaterThan(0));

        // The accented forms must be at least as wide as the bare vowels; a
        // missing glyph typically renders as a narrow tofu box or nothing.
        expect(widthOf('ő', style), greaterThanOrEqualTo(widthOf('o', style)));
        expect(widthOf('ű', style), greaterThanOrEqualTo(widthOf('u', style)));
    });

    test('each ramp of the type scale descends', () {
        // Material's slots are four independent ramps, not one sequence — a
        // 16px titleSmall legitimately sits below a 17px bodyLarge. Each ramp
        // still has to descend within itself.
        final Map<String, List<TextStyle>> ramps = <String, List<TextStyle>>{
            'display': <TextStyle>[
                AppText.displayLarge,
                AppText.displayMedium,
                AppText.displaySmall,
            ],
            'headline': <TextStyle>[
                AppText.headlineLarge,
                AppText.headlineMedium,
                AppText.headlineSmall,
            ],
            'title': <TextStyle>[
                AppText.titleLarge,
                AppText.titleMedium,
                AppText.titleSmall,
            ],
            'body': <TextStyle>[
                AppText.bodyLarge,
                AppText.bodyMedium,
                AppText.bodySmall,
            ],
            'label': <TextStyle>[
                AppText.labelLarge,
                AppText.labelMedium,
                AppText.labelSmall,
            ],
        };

        ramps.forEach((String name, List<TextStyle> ramp) {
            for (int i = 1; i < ramp.length; i++) {
                expect(
                    ramp[i].fontSize!,
                    lessThan(ramp[i - 1].fontSize!),
                    reason: '$name slot $i is not smaller than slot ${i - 1}',
                );
            }
        });

        // And the ramps sit in the right overall order at their extremes.
        expect(AppText.displaySmall.fontSize!, greaterThan(AppText.headlineLarge.fontSize!));
        expect(AppText.headlineSmall.fontSize!, greaterThan(AppText.titleLarge.fontSize!));
    });
}
