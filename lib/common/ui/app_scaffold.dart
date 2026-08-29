import 'package:flutter/material.dart';

import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';

/// The standard page shell.
///
/// Absorbs four patterns that used to be copy-pasted across the screens:
///
/// * the light page background;
/// * [centerScrollable] — the `LayoutBuilder → SingleChildScrollView →
///   ConstrainedBox(minHeight) → Center` sandwich that keeps content centred
///   but lets it scroll on small screens or at large system font sizes;
/// * [swipeToPop] — the whole-page left-to-right drag that pops the route,
///   which three screens each implemented by hand;
/// * [bottomBar] — a persistent action pinned above the safe area.
class AppScaffold extends StatelessWidget {
    /// Shown in a plain themed [AppBar]. Ignored when [appBar] is given.
    final String? title;

    /// Replaces the whole app bar — used by the home screen for its floating
    /// variant. Pass `null` with [title] `null` for a bar-less page.
    final PreferredSizeWidget? appBar;

    final Widget? leading;
    final List<Widget>? actions;

    /// Whether the app bar may show an automatic back arrow. Turn it off on
    /// screens the user must not step back from — the ones whose predecessor
    /// cleared the stack.
    final bool showBack;

    final Widget body;

    /// Pinned below [body], above the safe area. The screen's primary action.
    final Widget? bottomBar;

    final EdgeInsets padding;

    /// Centre [body] vertically, scrolling instead of overflowing.
    final bool centerScrollable;

    /// Pop the route on a left-to-right flick anywhere on the page.
    final bool swipeToPop;

    final Color? backgroundColor;

    final Widget? endDrawer;
    final GlobalKey<ScaffoldState>? scaffoldKey;
    final ValueChanged<bool>? onEndDrawerChanged;

    const AppScaffold({
        super.key,
        required this.body,
        this.title,
        this.appBar,
        this.leading,
        this.actions,
        this.showBack = true,
        this.bottomBar,
        this.padding = AppSpacing.page,
        this.centerScrollable = false,
        this.swipeToPop = false,
        this.backgroundColor,
        this.endDrawer,
        this.scaffoldKey,
        this.onEndDrawerChanged,
    });

    @override
    Widget build(BuildContext context) {
        Widget content = body;

        if (centerScrollable) {
            content = LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                    return SingleChildScrollView(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: Center(child: body),
                        ),
                    );
                },
            );
        }

        final Widget scaffold = Scaffold(
            key: scaffoldKey,
            backgroundColor: backgroundColor ?? AppColors.pageBg,
            endDrawer: endDrawer,
            onEndDrawerChanged: onEndDrawerChanged,
            appBar: appBar ??
                (title == null && leading == null && actions == null
                    ? null
                    : AppBar(
                        title: title == null ? null : Text(title!),
                        leading: leading,
                        actions: actions,
                        automaticallyImplyLeading: showBack,
                    )),
            body: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                        Expanded(
                            child: Padding(padding: padding, child: content),
                        ),
                        if (bottomBar != null)
                            Padding(
                                padding: EdgeInsets.fromLTRB(
                                    padding.left,
                                    AppSpacing.md,
                                    padding.right,
                                    AppSpacing.xl,
                                ),
                                child: bottomBar,
                            ),
                    ],
                ),
            ),
        );

        if (!swipeToPop) return scaffold;

        return GestureDetector(
            // A flick from anywhere on the page, not just the very left edge.
            onHorizontalDragEnd: (DragEndDetails details) {
                if ((details.primaryVelocity ?? 0) > 250) {
                    Navigator.of(context).pop();
                }
            },
            child: scaffold,
        );
    }
}
