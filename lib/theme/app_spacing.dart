import 'package:flutter/material.dart';

import 'package:getshap/theme/app_colors.dart';

/// A 4pt spacing scale. Replaces the 18 different `SizedBox` heights and 20
/// different `EdgeInsets` the screens used to invent individually.
abstract final class AppSpacing {
    static const double xxs = 2;
    static const double xs = 4;
    static const double sm = 8;
    static const double md = 12;
    static const double lg = 16;
    static const double xl = 20;
    static const double xxl = 24;
    static const double xxxl = 32;
    static const double huge = 40;
    static const double giant = 48;

    /// Standard horizontal breathing room for a page's content.
    static const EdgeInsets page = EdgeInsets.symmetric(horizontal: xl);

    /// Page content plus room above and below.
    static const EdgeInsets pageAll = EdgeInsets.fromLTRB(xl, lg, xl, xxl);

    /// Inside a card.
    static const EdgeInsets card = EdgeInsets.all(xl);
}

/// Corner radii. The old code used ten values between 6 and 30; these five
/// cover every one of those roles.
abstract final class AppRadius {
    static const double xs = 8;
    static const double sm = 12;
    static const double md = 16;
    static const double lg = 20;
    static const double xl = 28;

    /// Fully rounded ends, for chips and pills.
    static const double pill = 999;

    static BorderRadius all(double r) => BorderRadius.circular(r);
}

/// Elevation. All three are tinted with [AppColors.n900] rather than pure
/// black, so shadows sit in the same blue family as everything else and never
/// look like grey smudges on the tinted page.
///
/// The 3D button ledge is deliberately *not* here: it is a hard, zero-blur
/// shadow computed from the button's own face colour, and it lives in the
/// button.
abstract final class AppShadows {
    /// A card resting on the page.
    static const List<BoxShadow> sm = <BoxShadow>[
        BoxShadow(color: Color(0x0F101A2E), blurRadius: 8, offset: Offset(0, 2)),
    ];

    /// A card that should read as lifted — the tip panel, the video frame.
    static const List<BoxShadow> md = <BoxShadow>[
        BoxShadow(color: Color(0x14101A2E), blurRadius: 20, offset: Offset(0, 8)),
        BoxShadow(color: Color(0x0A101A2E), blurRadius: 4, offset: Offset(0, 1)),
    ];

    /// Dialogs and the floating app bar.
    static const List<BoxShadow> lg = <BoxShadow>[
        BoxShadow(color: Color(0x1F101A2E), blurRadius: 32, offset: Offset(0, 14)),
    ];
}
