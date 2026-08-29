import 'package:flutter/material.dart';

/// The single source of truth for colour in the app.
///
/// Everything is anchored on [brand500], which is the exact blue of the app
/// icon (sampled from `assets/icon/icon.png`). Nothing outside this file should
/// declare a colour literal.
///
/// The layout story is: **blue chrome, light content**. The splash, the app bar
/// and the side menu are brand blue with white on them; pages are a faintly
/// blue-tinted off-white with white cards and near-black text. That keeps the
/// white logo mark legible everywhere it appears without needing a second
/// artwork, and leaves the primary button as the one saturated element on an
/// otherwise calm page.
abstract final class AppColors {
    // ---------------------------------------------------------------- brand

    /// Faint tint for highlighted panels (e.g. a tip the user has not read).
    static const Color brand50 = Color(0xFFECF2FE);

    /// Selected chips, progress tracks on a brand-tinted surface.
    static const Color brand100 = Color(0xFFDCE7FD);

    /// Focus rings.
    static const Color brand200 = Color(0xFFBED2FA);

    /// **The brand.** The logo blue. White on it measures 5.36:1 (WCAG AA).
    static const Color brand500 = Color(0xFF165FEF);

    /// Pressed button face. `lerp(brand500, black, 0.14)`.
    static const Color brand600 = Color(0xFF1352CE);

    /// The 3D ledge under a primary button. `lerp(brand500, black, 0.28)` —
    /// the same darkening the pressable button has always applied, so the
    /// press effect is unchanged.
    static const Color brand700 = Color(0xFF1044AC);

    /// Deep end of the celebratory gradient. `lerp(brand500, black, 0.44)`.
    static const Color brand800 = Color(0xFF0C3586);

    /// Headings sitting on a brand-tinted panel.
    static const Color brand900 = Color(0xFF082559);

    // ------------------------------------------------------------- neutrals
    // Tinted towards the brand hue (~220°) rather than pure grey: this is what
    // makes the page read as a blue-tinted off-white instead of a grey sheet.

    /// Cards and sheets.
    static const Color surface = Color(0xFFFFFFFF);

    /// The page behind the cards.
    static const Color pageBg = Color(0xFFF4F7FC);

    /// Subtle fill: slider and progress tracks, unselected options.
    static const Color n100 = Color(0xFFEAEFF7);

    /// Borders and dividers. Also the disabled button face.
    static const Color n200 = Color(0xFFDCE3EF);

    /// Strong borders. Also the disabled button ledge.
    static const Color n300 = Color(0xFFC4CDDE);

    /// Muted icons and placeholders. 3.40:1 on [surface] — **never body text**.
    static const Color n400 = Color(0xFF98A3B8);

    /// Tertiary text. 4.88:1 on [surface] — right at AA, do not lighten.
    static const Color n500 = Color(0xFF67718A);

    /// Secondary text. 5.95:1 on [surface].
    static const Color n600 = Color(0xFF5A6478);

    /// Primary text. 17.4:1 on [surface], 16.2:1 on [pageBg].
    static const Color n900 = Color(0xFF101A2E);

    /// Everything on brand blue, and text on the dark video surface.
    static const Color onBrand = Color(0xFFFFFFFF);

    // ------------------------------------------------------------- semantic

    /// Success fills and the finish button. White on it is 5.43:1.
    static const Color success = Color(0xFF0B7A3D);
    static const Color successLedge = Color(0xFF085B2D);
    static const Color successSubtle = Color(0xFFE6F5EC);

    /// Only for display-sized celebratory text (≥24px): 3.37:1 on white.
    static const Color successBright = Color(0xFF12A150);

    static const Color warning = Color(0xFFC2760A);
    static const Color warningSubtle = Color(0xFFFFF3DF);

    /// Warning text on a light surface. 6.51:1 on [surface].
    static const Color warningText = Color(0xFF8A5000);

    /// Health warnings. White on it is 4.83:1.
    static const Color danger = Color(0xFFD92D20);
    static const Color dangerLedge = Color(0xFFA81E14);
    static const Color dangerSubtle = Color(0xFFFDECEA);

    // ---------------------------------------------------------------- streak
    // The flame gradient is decorative and always drawn at 84px or larger, so
    // it keeps its original saturated colours. Anything that *carries meaning*
    // next to it needs a darker partner, because #FF9800 on white is only
    // 2.16:1.

    static const Color flameA = Color(0xFFFFD54F);
    static const Color flameB = Color(0xFFFF9800);
    static const Color flameC = Color(0xFFF4511E);

    /// Workout-day markers. White on it is 5.18:1.
    static const Color flameInk = Color(0xFFC2410C);

    /// The band drawn across the days inside a streak.
    static const Color flameBand = Color(0xFFFFE3C2);

    /// Rest-day numerals on [flameBand]. 6.15:1.
    static const Color flameBandInk = Color(0xFF8A3E06);

    /// Streak-freeze days. White on it is 5.93:1.
    static const Color freeze = Color(0xFF0369A1);
    static const Color freezeSubtle = Color(0xFFE0F2FE);

    // ------------------------------------------------------------------- RPE
    // Two parallel scales over the same hues: [rpeBright] paints large areas
    // (the slider track gradient, the emoji badge glow), [rpeInk] is for
    // anything that has to be *read* — every entry clears AA on white.

    static const List<Color> rpeBright = <Color>[
        Color(0xFF22A45D),
        Color(0xFF7FBB3D),
        Color(0xFFF2C230),
        Color(0xFFF3831E),
        Color(0xFFE23B3B),
    ];

    static const List<Color> rpeInk = <Color>[
        Color(0xFF0B7A3D),
        Color(0xFF4C7A1B),
        Color(0xFF8A5000),
        Color(0xFFB4470B),
        Color(0xFFC0271F),
    ];

    // ------------------------------------------------------------------ misc

    /// The letterbox behind an exercise video.
    static const Color videoBackdrop = Color(0xFF0B1220);
}
