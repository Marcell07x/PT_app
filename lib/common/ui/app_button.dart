import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';

/// What the button means.
enum AppButtonVariant {
    /// The one action the screen wants. Brand blue.
    primary,

    /// A step back or aside. White face, quiet label.
    secondary,

    /// Finishing something. Used on the congratulations screen.
    success,

    /// Destructive or health-critical acknowledgement.
    danger,

    /// White face with a brand-blue label, for use *on* a saturated brand
    /// background — the congratulations screen.
    inverse,

    /// Text-only, no ledge. For tertiary actions inside a card.
    ghost,
}

/// How big.
enum AppButtonSize {
    /// 52px. Inline actions: workout navigation, permission prompts.
    md,

    /// 60px. The bottom-of-screen primary action.
    lg,

    /// 88px. The single call to action on the home screen.
    hero,
}

/// The app's button.
///
/// It keeps the "3D ledge" press feel the app has always had — the face sits on
/// a darker ledge and travels down onto it when tapped — but standardises it.
/// The nine hand-rolled call sites this replaces used five different heights,
/// two radii, two depths and two different blues.
///
/// The ledge is a **signal, not a style**: it marks the one action a screen is
/// asking for. It therefore appears on [AppButtonVariant.primary] and
/// [AppButtonVariant.inverse] only, at a single 3px depth rather than the
/// old 4/5/6px that scaled with the button. Raising every button on the page
/// meant none of them read as raised — a back arrow does not deserve the same
/// physicality as "start workout". Everything else gets [AppShadows.sm] and a
/// 1px travel on press.
///
/// Beyond the tidy-up it adds three things the old widget lacked: an ambient
/// shadow (on the old dark background the page did that job for free, on a
/// light page it does not), a haptic tick, and [Semantics] — the previous
/// `GestureDetector` announced nothing at all to a screen reader.
class AppButton extends StatefulWidget {
    /// The label. Rendered in [AppText.button], or [AppText.buttonHero] at
    /// [AppButtonSize.hero].
    final String label;

    /// Null renders the disabled state.
    final VoidCallback? onPressed;

    final AppButtonVariant variant;
    final AppButtonSize size;

    final IconData? leadingIcon;
    final IconData? trailingIcon;

    /// Stretch to the available width. Turn off for a button that should hug
    /// its label.
    final bool expand;

    /// Fixed width, overriding [expand].
    final double? width;

    /// Renders an icon-only square button instead of a label.
    final IconData? _iconOnly;

    const AppButton({
        super.key,
        required this.label,
        required this.onPressed,
        this.variant = AppButtonVariant.primary,
        this.size = AppButtonSize.lg,
        this.leadingIcon,
        this.trailingIcon,
        this.expand = true,
        this.width,
    }) : _iconOnly = null;

    /// A square icon button — the workout screen's "previous exercise" arrow.
    /// [label] is not drawn; it becomes the accessibility label.
    const AppButton.icon({
        super.key,
        required IconData icon,
        required this.label,
        required this.onPressed,
        this.variant = AppButtonVariant.secondary,
        this.size = AppButtonSize.md,
    })  : _iconOnly = icon,
            leadingIcon = null,
            trailingIcon = null,
            expand = false,
            width = null;

    @override
    State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
    bool _pressed = false;

    bool get _enabled => widget.onPressed != null;

    double get _height => switch (widget.size) {
        AppButtonSize.md => 52,
        AppButtonSize.lg => 60,
        AppButtonSize.hero => 88,
    };

    double get _radius => switch (widget.size) {
        AppButtonSize.md => AppRadius.sm,
        AppButtonSize.lg => AppRadius.md,
        AppButtonSize.hero => AppRadius.lg,
    };

    /// The one ledge depth in the app. Independent of size: it says "this is
    /// the action", and that does not get truer on a bigger button.
    static const double _ledgeDepth = 3;

    /// Only the variants that carry a screen's primary action are raised.
    bool get _hasLedge =>
        _enabled &&
        (widget.variant == AppButtonVariant.primary ||
            widget.variant == AppButtonVariant.inverse);

    double get _depth => _hasLedge ? _ledgeDepth : 0;

    /// How far the face travels on press. Flat buttons still move, just barely,
    /// so a tap is never silent.
    double get _travel => _hasLedge ? _ledgeDepth : 1;

    /// (face, ledge, label) for the current variant and enabled state.
    (Color, Color, Color) get _palette {
        if (!_enabled) {
            return (AppColors.n200, AppColors.n300, AppColors.n500);
        }
        return switch (widget.variant) {
            AppButtonVariant.primary => (
                AppColors.brand500,
                AppColors.brand700,
                AppColors.onBrand,
            ),
            AppButtonVariant.secondary => (
                AppColors.surface,
                AppColors.n300,
                AppColors.n600,
            ),
            AppButtonVariant.success => (
                AppColors.success,
                AppColors.successLedge,
                AppColors.onBrand,
            ),
            AppButtonVariant.danger => (
                AppColors.danger,
                AppColors.dangerLedge,
                AppColors.onBrand,
            ),
            AppButtonVariant.inverse => (
                AppColors.surface,
                AppColors.brand200,
                AppColors.brand600,
            ),
            AppButtonVariant.ghost => (
                Colors.transparent,
                Colors.transparent,
                AppColors.brand500,
            ),
        };
    }

    bool get _isGhost => widget.variant == AppButtonVariant.ghost && _enabled;

    void _setPressed(bool value) {
        if (!_enabled || value == _pressed) return;
        if (value) HapticFeedback.selectionClick();
        setState(() => _pressed = value);
    }

    @override
    Widget build(BuildContext context) {
        final (Color face, Color ledge, Color ink) = _palette;
        final double depth = _isGhost ? 0 : _depth;
        final double travel = _isGhost ? 0 : _travel;

        final TextStyle labelStyle =
            (widget.size == AppButtonSize.hero ? AppText.buttonHero : AppText.button)
                .copyWith(color: ink);

        final Widget content = widget._iconOnly != null
            ? Icon(widget._iconOnly, color: ink, size: 24)
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    if (widget.leadingIcon != null) ...<Widget>[
                        Icon(widget.leadingIcon, color: ink, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                    ],
                    Flexible(
                        child: Text(
                            widget.label,
                            style: labelStyle,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                        ),
                    ),
                    if (widget.trailingIcon != null) ...<Widget>[
                        const SizedBox(width: AppSpacing.sm),
                        Icon(widget.trailingIcon, color: ink, size: 20),
                    ],
                ],
            );

        final Widget surface = AnimatedContainer(
            duration: const Duration(milliseconds: 70),
            width: widget._iconOnly != null ? _height : widget.width,
            height: _height,
            padding: widget._iconOnly != null
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            transform: Matrix4.translationValues(0, _pressed ? travel : 0, 0),
            decoration: BoxDecoration(
                color: face,
                borderRadius: AppRadius.all(_radius),
                border: widget.variant == AppButtonVariant.secondary && _enabled
                    ? Border.all(color: AppColors.n200)
                    : null,
                boxShadow: _isGhost
                    ? null
                    : _hasLedge
                        ? <BoxShadow>[
                            // Ambient lift, so the button reads as an object on
                            // the light page rather than a flat rectangle.
                            BoxShadow(
                                color: const Color(0x14101A2E),
                                offset: Offset(0, _pressed ? 2 : depth + 2),
                                blurRadius: _pressed ? 6 : 10,
                            ),
                            // The hard coloured ledge: zero blur, so it reads as
                            // a solid side rather than a shadow.
                            BoxShadow(
                                color: ledge,
                                offset: Offset(0, _pressed ? 0 : depth),
                                blurRadius: 0,
                            ),
                        ]
                        // Everything else rests on the page instead of standing
                        // on it.
                        : _pressed
                            ? const <BoxShadow>[]
                            : AppShadows.sm,
            ),
            alignment: Alignment.center,
            child: content,
        );

        return Semantics(
            button: true,
            enabled: _enabled,
            label: widget.label,
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (_) => _setPressed(true),
                onTapCancel: () => _setPressed(false),
                onTapUp: (_) {
                    _setPressed(false);
                    widget.onPressed?.call();
                },
                child: widget.expand
                    ? SizedBox(width: double.infinity, child: surface)
                    : surface,
            ),
        );
    }
}
