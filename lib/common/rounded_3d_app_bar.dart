import 'package:flutter/material.dart';

/// A floating, rounded "3D" app bar that can be dropped into any
/// `Scaffold.appBar` slot (it implements [PreferredSizeWidget]).
///
/// It reuses the same flat-3D language as [Pressable3DButton] and the home
/// tip panel: the bar sits on a darker [edgeColor] ledge (a hard, zero-blur
/// shadow) so it looks raised off the surface, its corners are rounded, and a
/// small [topGap] above it lets the page background show through so the bar
/// appears to float.
///
/// Everything is configurable so the same look can be reused on other screens:
/// pass a [title]/[leading]/[actions] like a normal [AppBar], and tweak
/// [backgroundColor], [edgeColor], [borderRadius], [depth], [topGap] or
/// [horizontalMargin] to restyle it.
///
/// Tip: because of the [topGap] and side margins, set the surrounding
/// `Scaffold.backgroundColor` (or use `extendBodyBehindAppBar: true`) to match
/// the page background so the gap around the bar blends in seamlessly.
class Rounded3DAppBar extends StatelessWidget implements PreferredSizeWidget {
    /// Main content of the bar (usually a [Text] or a small widget). Left
    /// aligned by default; see [centerTitle].
    final Widget? title;

    /// Optional widget before the title (e.g. a back button).
    final Widget? leading;

    /// Optional trailing widgets (e.g. a menu button).
    final List<Widget>? actions;

    /// Face colour of the bar.
    final Color backgroundColor;

    /// Darker ledge colour that creates the 3D depth. Defaults to a darkened
    /// [backgroundColor].
    final Color? edgeColor;

    /// Optional face gradient. When null a subtle vertical sheen is derived
    /// from [backgroundColor] (lighter at the top) for a glossier 3D look.
    final Gradient? gradient;

    /// Default colour applied to icons and text inside the bar.
    final Color foregroundColor;

    /// Corner radius of the bar.
    final double borderRadius;

    /// Height of the 3D ledge below the bar.
    final double depth;

    /// Small gap above the bar (below the status bar) so it appears to float.
    final double topGap;

    /// Left/right margin so the rounded corners and ledge are visible.
    final double horizontalMargin;

    /// Height of the bar face itself (excludes the status bar, [topGap] and
    /// [depth]).
    final double height;

    /// Centre the [title] instead of left-aligning it.
    final bool centerTitle;

    const Rounded3DAppBar({
        super.key,
        this.title,
        this.leading,
        this.actions,
        this.backgroundColor = const Color(0xFF2E6BF0),
        this.edgeColor,
        this.gradient,
        this.foregroundColor = Colors.white,
        this.borderRadius = 20,
        this.depth = 6,
        this.topGap = 16,
        this.horizontalMargin = 12,
        this.height = kToolbarHeight,
        this.centerTitle = false,
    });

    static Color _darken(Color c, [double amount = 0.30]) =>
        Color.lerp(c, Colors.black, amount)!;
    static Color _lighten(Color c, [double amount = 0.14]) =>
        Color.lerp(c, Colors.white, amount)!;

    @override
    Size get preferredSize => Size.fromHeight(topGap + height + depth);

    @override
    Widget build(BuildContext context) {
        final Color edge = edgeColor ?? _darken(backgroundColor);
        final Gradient face = gradient ??
            LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_lighten(backgroundColor), backgroundColor],
            );

        final Widget bar = Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                gradient: face,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                    // Soft ambient shadow so the bar reads as floating.
                    BoxShadow(
                        color: const Color(0x33000000),
                        offset: Offset(0, depth + 3),
                        blurRadius: 14,
                    ),
                    // Hard coloured ledge for the flat-3D depth (matches the
                    // app's buttons / tip panel).
                    BoxShadow(
                        color: edge,
                        offset: Offset(0, depth),
                        blurRadius: 0,
                    ),
                ],
            ),
            child: IconTheme.merge(
                data: IconThemeData(color: foregroundColor),
                child: DefaultTextStyle.merge(
                    style: TextStyle(
                        color: foregroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                    ),
                    child: Row(
                        children: [
                            ?leading,
                            Expanded(
                                child: Align(
                                    alignment: centerTitle
                                        ? Alignment.center
                                        : Alignment.centerLeft,
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            left: leading == null ? 8 : 4,
                                        ),
                                        child: title ?? const SizedBox.shrink(),
                                    ),
                                ),
                            ),
                            if (actions != null) ...actions!,
                        ],
                    ),
                ),
            ),
        );

        // SafeArea keeps the bar below the status bar; [topGap] adds the little
        // float gap, [depth] reserves room for the ledge so the body starts
        // below it.
        return SafeArea(
            bottom: false,
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    horizontalMargin,
                    topGap,
                    horizontalMargin,
                    depth,
                ),
                child: bar,
            ),
        );
    }
}
