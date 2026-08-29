import 'package:flutter/material.dart';

/// The app's type scale, in Manrope.
///
/// ## Why every style sets `fontVariations`
///
/// `assets/fonts/Manrope-Variable.ttf` is a **variable** font whose default
/// instance is ExtraLight (`wght` 200). Flutter does not map [FontWeight] onto
/// a variable axis on its own, so a style that sets only `fontWeight` renders
/// thin (or synthetically smeared). Every style below therefore carries both:
/// [FontVariation] drives the actual rendering, [FontWeight] keeps the fallback
/// font and accessibility metadata correct.
///
/// The practical rule: **never reach for `copyWith(fontWeight: …)`** — it would
/// leave the variation behind and silently do nothing. Use [weight] instead.
abstract final class AppText {
    static const String family = 'Manrope';

    /// Weights actually used: 400 body · 600 medium emphasis · 700 titles and
    /// buttons · 800 display. Manrope's axis runs 200–800, so there is no 900
    /// — the old `FontWeight.w900` call sites map onto 800.
    static FontWeight _fontWeight(int wght) =>
        FontWeight.values[(wght ~/ 100) - 1];

    static TextStyle _s(
        double size,
        int wght, {
        double? height,
        double? tracking,
    }) {
        return TextStyle(
            fontFamily: family,
            fontSize: size,
            height: height,
            letterSpacing: tracking,
            fontWeight: _fontWeight(wght),
            fontVariations: <FontVariation>[
                FontVariation('wght', wght.toDouble()),
            ],
        );
    }

    /// Re-weights an existing style, keeping the variable axis in step.
    static TextStyle weight(TextStyle base, int wght) => base.copyWith(
        fontWeight: _fontWeight(wght),
        fontVariations: <FontVariation>[FontVariation('wght', wght.toDouble())],
    );

    /// Fixed-width digits. Needed wherever a number animates or counts up —
    /// the streak counter and the RPE value — otherwise the layout jitters as
    /// digit widths change.
    static TextStyle numeral(TextStyle base) => base.copyWith(
        fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
    );

    // ------------------------------------------------------------- the scale
    // 11 sizes and 4 weights, replacing 23 sizes and 9 weight spellings.

    /// The streak number on the streak page.
    static final TextStyle displayLarge = _s(84, 800, height: 1.00, tracking: -1.5);

    /// The streak number in the congratulations animation.
    static final TextStyle displayMedium = _s(72, 800, height: 1.00, tracking: -1.2);

    /// The RPE value.
    static final TextStyle displaySmall = _s(48, 800, height: 1.05, tracking: -0.8);

    /// "Congratulations".
    static final TextStyle headlineLarge = _s(34, 800, height: 1.15, tracking: -0.5);

    /// Questionnaire titles, the feedback question.
    static final TextStyle headlineMedium = _s(28, 700, height: 1.20, tracking: -0.3);

    /// Exercise names, the rest-day message.
    static final TextStyle headlineSmall = _s(24, 700, height: 1.25);

    /// App bar titles.
    static final TextStyle titleLarge = _s(20, 700, height: 1.30);

    /// Rep counts, section headings.
    static final TextStyle titleMedium = _s(18, 700, height: 1.35, tracking: 0.2);

    /// Calendar month, sub-labels.
    static final TextStyle titleSmall = _s(16, 600, height: 1.40);

    /// Long-form reading: the tip detail, the consent intro.
    static final TextStyle bodyLarge = _s(17, 400, height: 1.50);

    /// The default body size.
    static final TextStyle bodyMedium = _s(15, 400, height: 1.50);

    /// Scale ends, metadata.
    static final TextStyle bodySmall = _s(13, 400, height: 1.45);

    /// Small button labels.
    static final TextStyle labelLarge = _s(15, 700, tracking: 0.3);

    /// Card eyebrows: "TIP", "FEEDBACK".
    static final TextStyle labelMedium = _s(13, 700, tracking: 0.8);

    /// Calendar weekday initials.
    static final TextStyle labelSmall = _s(11, 600, tracking: 1.2);

    // --------------------------------------------------------- named extras
    // These carry a role rather than a size slot, so they sit outside the
    // TextTheme.

    /// The one big call to action on the home screen.
    static final TextStyle buttonHero = _s(22, 800, tracking: 0.4);

    /// Every other button label.
    static final TextStyle button = _s(17, 700, tracking: 0.2);

    /// Small uppercase label above a block of content.
    static final TextStyle eyebrow = _s(12, 700, tracking: 1.6);

    static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
    );
}
