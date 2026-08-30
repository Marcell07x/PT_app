import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_theme.dart';

/// Branded launch splash: a full brand-blue field with the app's white logo
/// mark fading and scaling in at the centre. After [minDuration] it replaces
/// itself with [nextBuilder]'s screen.
///
/// The blue field is not decoration — `logo_mark.png` is pure white, so it
/// needs a saturated ground to be visible at all. Keeping the splash blue also
/// lets the native Android and iOS launch screens use the same colour, so the
/// cold start is one continuous blue from the launcher icon to the first
/// Flutter frame.
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
            PageRouteBuilder<void>(
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
        // No app bar here, so AppBarTheme's overlay style never applies — set it
        // directly or the status bar icons stay dark on the blue. Both bars take
        // this screen's own blue; what used to be wrong was not the colour but
        // that nothing set it back afterwards, so it followed the user through
        // the entire app.
        return AnnotatedRegion<SystemUiOverlayStyle>(
            value: AppTheme.systemBarsOn(AppColors.brand500),
            child: Scaffold(
                backgroundColor: AppColors.brand500,
                body: Center(
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
