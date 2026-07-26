import 'package:flutter/material.dart';
import 'package:getshap/common/bokeh_background.dart';

/// Branded launch splash: the bokeh background with the app's logo mark
/// (the white "S" and the exponential curve, no blue box) fading in at the
/// centre. After [minDuration] it replaces itself with [nextBuilder]'s screen.
class SplashScreen extends StatefulWidget {
    /// Builds the screen to show once the splash finishes (home or onboarding).
    final WidgetBuilder nextBuilder;

    /// How long the splash stays visible before navigating on.
    final Duration minDuration;

    const SplashScreen({
        super.key,
        required this.nextBuilder,
        this.minDuration = const Duration(milliseconds: 1900),
    });

    @override
    State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
    late final AnimationController _controller;
    late final Animation<double> _fade;
    late final Animation<double> _scale;

    @override
    void initState() {
        super.initState();
        _controller = AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 900),
        );
        _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
        _scale = Tween<double>(begin: 0.82, end: 1.0).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
        );
        _controller.forward();
        _scheduleNext();
    }

    Future<void> _scheduleNext() async {
        await Future.delayed(widget.minDuration);
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
            PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 450),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    widget.nextBuilder(context),
                transitionsBuilder: (context, animation, _, child) =>
                    FadeTransition(opacity: animation, child: child),
            ),
        );
    }

    @override
    void dispose() {
        _controller.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: BokehBackground(
                child: Center(
                    child: FadeTransition(
                        opacity: _fade,
                        child: ScaleTransition(
                            scale: _scale,
                            child: Image.asset(
                                'assets/icon/logo_mark.png',
                                width: MediaQuery.of(context).size.width * 0.52,
                                filterQuality: FilterQuality.high,
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
}
