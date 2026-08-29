import 'package:flutter/material.dart';

import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';

/// The home screen's floating app bar: a rounded brand-blue slab that sits on
/// a darker ledge, with a gap above it so the page shows through and the bar
/// reads as raised.
///
/// Every *other* screen uses a plain [AppBar] — `AppBarTheme` already gives
/// those the same blue, the same title style and the same status-bar
/// treatment. This variant exists only for the front door.
///
/// The press language matches `AppButton`: hard zero-blur ledge plus a soft
/// ambient shadow.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
    final Widget? title;
    final Widget? leading;
    final List<Widget>? actions;

    /// Height of the bar face, excluding the status bar, [topGap] and [depth].
    final double height;

    /// The 3D ledge below the bar.
    final double depth;

    /// Gap between the status bar and the bar, so it appears to float.
    final double topGap;

    /// Side margin, so the rounded corners and the ledge are visible.
    final double horizontalMargin;

    const AppTopBar({
        super.key,
        this.title,
        this.leading,
        this.actions,
        this.height = kToolbarHeight,
        this.depth = 5,
        this.topGap = 12,
        this.horizontalMargin = AppSpacing.md,
    });

    // Must stay in step with the padding below, or the body slides under the
    // bar without any warning.
    @override
    Size get preferredSize => Size.fromHeight(topGap + height + depth);

    @override
    Widget build(BuildContext context) {
        final Widget bar = Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            decoration: BoxDecoration(
                color: AppColors.brand500,
                borderRadius: AppRadius.all(AppRadius.lg),
                boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: const Color(0x1F101A2E),
                        offset: Offset(0, depth + 3),
                        blurRadius: 14,
                    ),
                    BoxShadow(
                        color: AppColors.brand700,
                        offset: Offset(0, depth),
                        blurRadius: 0,
                    ),
                ],
            ),
            child: IconTheme.merge(
                data: const IconThemeData(color: AppColors.onBrand),
                child: DefaultTextStyle.merge(
                    style: Theme.of(context).appBarTheme.titleTextStyle ??
                        const TextStyle(color: AppColors.onBrand),
                    child: Row(
                        children: <Widget>[
                            ?leading,
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: leading == null ? AppSpacing.sm : AppSpacing.xs,
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
                    depth,
                ),
                child: bar,
            ),
        );
    }
}
