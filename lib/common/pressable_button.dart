import 'package:flutter/material.dart';

/// A button with a pressable "3D" bottom edge: it sits on a darker [edgeColor]
/// ledge and pushes down onto it when tapped (the effect used on the
/// congratulations screen's finish button).
///
/// Shape is fully configurable ([borderRadius], [width], [height], [padding])
/// so it can wrap existing buttons without changing their look — only adding
/// the 3D press effect. Pass `onPressed: null` to render a disabled state.
class Pressable3DButton extends StatefulWidget {
    final Widget child;
    final VoidCallback? onPressed;

    /// Face colour when enabled.
    final Color color;

    /// Darker ledge colour. Defaults to a darkened [color].
    final Color? edgeColor;

    /// Face colour when [onPressed] is null.
    final Color disabledColor;

    /// Height of the 3D ledge (how far the button travels when pressed).
    final double depth;

    final double borderRadius;
    final double? width;
    final double? height;
    final EdgeInsetsGeometry? padding;

    const Pressable3DButton({
        super.key,
        required this.child,
        required this.onPressed,
        required this.color,
        this.edgeColor,
        this.disabledColor = const Color(0xFFBDBDBD),
        this.depth = 4,
        this.borderRadius = 18,
        this.width,
        this.height,
        this.padding,
    });

    @override
    State<Pressable3DButton> createState() => _Pressable3DButtonState();
}

class _Pressable3DButtonState extends State<Pressable3DButton> {
    bool _pressed = false;

    bool get _enabled => widget.onPressed != null;

    static Color _darken(Color c) => Color.lerp(c, Colors.black, 0.28)!;

    Color get _face => _enabled ? widget.color : widget.disabledColor;

    Color get _edge => _enabled
        ? (widget.edgeColor ?? _darken(widget.color))
        : _darken(widget.disabledColor);

    void _setPressed(bool value) {
        if (!_enabled) return;
        setState(() => _pressed = value);
    }

    @override
    Widget build(BuildContext context) {
        final Widget content =
            _enabled ? widget.child : Opacity(opacity: 0.75, child: widget.child);

        return GestureDetector(
            onTapDown: (_) => _setPressed(true),
            onTapCancel: () => _setPressed(false),
            onTapUp: (_) {
                _setPressed(false);
                widget.onPressed?.call();
            },
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 70),
                width: widget.width,
                height: widget.height,
                padding: widget.padding,
                transform: Matrix4.translationValues(0, _pressed ? widget.depth : 0, 0),
                decoration: BoxDecoration(
                    color: _face,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    boxShadow: [
                        BoxShadow(
                            color: _edge,
                            offset: Offset(0, _pressed ? 0 : widget.depth),
                            blurRadius: 0,
                        ),
                    ],
                ),
                alignment: Alignment.center,
                child: content,
            ),
        );
    }
}
