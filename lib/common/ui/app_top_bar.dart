import 'package:flutter/material.dart';

import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';

/// The home screen's app bar.
///
/// It used to be a rounded brand-blue slab sitting on a darker ledge. It is now
/// what every other screen's header is: the page background, running straight
/// through, with the content sitting on it. The blue moved to where a decision
/// is — the primary button — and the ledge to the one button that carries it.
///
/// The widget survives the change because the home screen needs a bar with no
/// title and a custom leading (the streak flame), and because
/// [preferredSize] has to stay in step with the padding below it or the body
/// slides under the bar with no warning.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
    final Widget? title;
    final Widget? leading;
    final List<Widget>? actions;

    /// Height of the bar content, excluding the status bar and [topGap].
    final double height;

    /// Gap between the status bar and the bar content.
    final double topGap;

    /// Side margin for the bar content.
    final double horizontalMargin;

    const AppTopBar({
        super.key,
        this.title,
        this.leading,
        this.actions,
        this.height = kToolbarHeight,
        this.topGap = AppSpacing.sm,
        this.horizontalMargin = AppSpacing.lg,
    });

    // Must stay in step with the padding below.
    @override
    Size get preferredSize => Size.fromHeight(topGap + height);

    @override
    Widget build(BuildContext context) {
        final Widget bar = SizedBox(
            height: height,
            child: IconTheme.merge(
                data: const IconThemeData(color: AppColors.n600),
                child: DefaultTextStyle.merge(
                    style: Theme.of(context).appBarTheme.titleTextStyle ??
                        const TextStyle(color: AppColors.n900),
                    child: Row(
                        children: <Widget>[
                            ?leading,
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: leading == null ? 0 : AppSpacing.xs,
                                    ),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
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

        return SafeArea(
            bottom: false,
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    horizontalMargin,
                    topGap,
                    horizontalMargin,
                    0,
                ),
                child: bar,
            ),
        );
    }
}
