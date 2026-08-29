import 'package:flutter/material.dart';

import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';

/// A white panel on the page.
///
/// Replaces the fourteen hand-rolled `Container(decoration: BoxDecoration(…))`
/// blocks the screens used to carry around, two of which ([AppCard.section] on
/// the home screen and the tip detail screen) were literally the same widget
/// written twice.
class AppCard extends StatelessWidget {
    final Widget child;
    final EdgeInsetsGeometry? padding;
    final Color? color;
    final double radius;
    final List<BoxShadow>? shadow;
    final VoidCallback? onTap;

    /// Set by [AppCard.section]: a small uppercase label above a hairline rule.
    final String? _eyebrow;

    /// Set by [AppCard.notice]: the colour of the left rule.
    final Color? _accent;

    const AppCard({
        super.key,
        required this.child,
        this.padding,
        this.color,
        this.radius = AppRadius.md,
        this.shadow,
        this.onTap,
    })  : _eyebrow = null,
            _accent = null;

    /// A card that leads with a small uppercase label — "TIP", "FEEDBACK" —
    /// separated from the body by a hairline.
    const AppCard.section({
        super.key,
        required String eyebrow,
        required this.child,
        this.color,
        this.radius = AppRadius.md,
        this.shadow,
        this.onTap,
    })  : _eyebrow = eyebrow,
            _accent = null,
            padding = null;

    /// A tinted panel with a coloured rule down its left edge: health warnings,
    /// the "the documents changed" notice.
    const AppCard.notice({
        super.key,
        required Color accent,
        required this.child,
        this.color,
        this.padding,
        this.radius = AppRadius.sm,
    })  : _accent = accent,
            _eyebrow = null,
            shadow = null,
            onTap = null;

    @override
    Widget build(BuildContext context) {
        final Widget body = _accent != null
            ? _buildNotice()
            : _eyebrow != null
                ? _buildSection()
                : _buildPlain();

        if (onTap == null) return body;

        return GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: body,
        );
    }

    Widget _buildPlain() {
        return Container(
            width: double.infinity,
            padding: padding ?? AppSpacing.card,
            decoration: BoxDecoration(
                color: color ?? AppColors.surface,
                borderRadius: AppRadius.all(radius),
                boxShadow: shadow ?? AppShadows.sm,
            ),
            child: child,
        );
    }

    Widget _buildSection() {
        return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: color ?? AppColors.surface,
                borderRadius: AppRadius.all(radius),
                boxShadow: shadow ?? AppShadows.md,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.fromLTRB(
                            AppSpacing.xl,
                            AppSpacing.lg,
                            AppSpacing.xl,
                            AppSpacing.md,
                        ),
                        child: Text(
                            _eyebrow!.toUpperCase(),
                            style: AppText.eyebrow.copyWith(color: AppColors.brand500),
                        ),
                    ),
                    const Divider(height: 1),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(
                            AppSpacing.xl,
                            AppSpacing.lg,
                            AppSpacing.xl,
                            AppSpacing.xl,
                        ),
                        child: child,
                    ),
                ],
            ),
        );
    }

    Widget _buildNotice() {
        return Container(
            width: double.infinity,
            padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
                color: color ?? AppColors.surface,
                borderRadius: AppRadius.all(radius),
                border: Border(left: BorderSide(color: _accent!, width: 4)),
            ),
            child: child,
        );
    }
}
