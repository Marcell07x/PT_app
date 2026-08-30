import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';

/// Which page the side menu is currently showing.
enum SideMenuView { menu, contact }

class SideMenu extends StatelessWidget {
    final VoidCallback onSetLevelPressed;
    final VoidCallback onAdvanceDayPressed;
    final VoidCallback onDumpStatePressed;
    final VoidCallback onFormPressed;
    // The sub-pages are shown inside this same drawer. The parent owns the
    // current view so the Android back button can step
    // sub-page -> menu -> home.
    final SideMenuView view;
    final VoidCallback onContactPressed;
    final VoidCallback onBackToMenuPressed;

    const SideMenu({
        super.key,
        required this.onSetLevelPressed,
        required this.onAdvanceDayPressed,
        required this.onDumpStatePressed,
        required this.onFormPressed,
        required this.view,
        required this.onContactPressed,
        required this.onBackToMenuPressed,
    });

    Future<void> _openInstagram() async {
        await launchUrl(
            Uri.parse('https://www.instagram.com/bodnar__marcell'),
            mode: LaunchMode.externalApplication,
        );
    }

    Future<void> _openEmail() async {
        // mailto opens the default mail composer (Gmail on most Android devices,
        // Mail on iOS) with the address pre-filled.
        await launchUrl(Uri(scheme: 'mailto', path: 'bmarci891@gmail.com'));
    }

    @override
    Widget build(BuildContext context) {
        final double menuWidth = MediaQuery.of(context).size.width * 0.78;

        // Full-height white panel reaching the top of the screen. Only the left
        // corners are rounded (the right edge is the screen edge); the
        // elevation casts a soft shadow onto the page behind it.
        //
        // It used to be saturated blue, as chrome alongside the app bar and the
        // splash. The app bar is no longer blue, and a menu is not a decision,
        // so the panel joins the light content instead.
        return Drawer(
            width: menuWidth,
            backgroundColor: AppColors.surface,
            elevation: 12,
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.xl),
                    bottomLeft: Radius.circular(AppRadius.xl),
                ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    _buildHeader(context),
                    Expanded(child: _buildBody(context)),
                ],
            ),
        );
    }

    Widget _buildBody(BuildContext context) {
        switch (view) {
            case SideMenuView.contact:
                return _buildContactView(context);
            case SideMenuView.menu:
                return _buildMenuView(context);
        }
    }

    /// Branded header band: the logo mark and wordmark, separated from the list
    /// below by a hairline.
    ///
    /// The bundled mark is white, for the blue splash. On the white panel it
    /// would be invisible, so it is tinted to the brand blue here rather than
    /// shipping a second artwork.
    Widget _buildHeader(BuildContext context) {
        final double topPad = MediaQuery.of(context).padding.top;

        return Container(
            padding: EdgeInsets.fromLTRB(
                AppSpacing.xl,
                topPad + AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
            ),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.n200)),
            ),
            child: Row(
                children: [
                    Image.asset(
                        'assets/icon/logo_mark.png',
                        width: 32,
                        height: 32,
                        filterQuality: FilterQuality.high,
                        color: AppColors.brand500,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                        'GetShap',
                        style: AppText.titleLarge.copyWith(
                            color: AppColors.n900,
                            letterSpacing: 0.3,
                        ),
                    ),
                ],
            ),
        );
    }

    /// Shared chrome for both pages of the menu, with a consistent row shape.
    Widget _menuList({required List<Widget> children}) {
        return ListTileTheme(
            data: ListTileThemeData(
                iconColor: AppColors.n600,
                textColor: AppColors.n900,
                titleTextStyle: AppText.titleSmall.copyWith(
                    color: AppColors.n900,
                ),
            ),
            child: ListView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                children: children,
            ),
        );
    }

    Widget _buildMenuView(BuildContext context) {
        final loc = AppLocalizations.of(context)!;
        return _menuList(
            children: [
                ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(loc.contact),
                    onTap: onContactPressed,
                ),
                // The menu is available in release mode but these options
                // are only visible when in debug mode. They now say so: four
                // developer tools sitting flush against "Contact" read as
                // shipped features to anyone looking over your shoulder.
                if (kDebugMode) ...[
                    const Padding(
                        padding: EdgeInsets.fromLTRB(
                            AppSpacing.xl,
                            AppSpacing.xxl,
                            AppSpacing.xl,
                            AppSpacing.sm,
                        ),
                        child: _DebugHeading(),
                    ),
                    ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Set Level'),
                        onTap: onSetLevelPressed,
                    ),
                    ListTile(
                        leading: const Icon(Icons.fast_forward),
                        title: const Text('Advance day(s)'),
                        onTap: onAdvanceDayPressed,
                    ),
                    ListTile(
                        leading: const Icon(Icons.bug_report),
                        title: const Text('Dump state'),
                        onTap: onDumpStatePressed,
                    ),
                    ListTile(
                        leading: const Icon(Icons.assignment),
                        title: Text(loc.form),
                        onTap: onFormPressed,
                    ),
                ],
            ],
        );
    }

    Widget _buildContactView(BuildContext context) {
        final loc = AppLocalizations.of(context)!;
        return _menuList(
            children: [
                _buildBackTile(loc),
                const Divider(height: 1),
                Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        AppSpacing.xl,
                        AppSpacing.xl,
                        AppSpacing.md,
                    ),
                    child: Text(
                        loc.infoIntro,
                        style: AppText.bodyMedium.copyWith(color: AppColors.n600),
                    ),
                ),
                _buildLinkTile(
                    leading: const _InstagramGlyph(),
                    label: loc.instagramLink,
                    onTap: _openInstagram,
                ),
                _buildLinkTile(
                    leading: const Icon(Icons.email_outlined),
                    label: loc.emailLink,
                    onTap: _openEmail,
                ),
            ],
        );
    }

    Widget _buildBackTile(AppLocalizations loc) {
        return ListTile(
            leading: const Icon(Icons.arrow_back),
            title: Text(loc.goback),
            onTap: onBackToMenuPressed,
        );
    }

    /// Base size for a contact link. Deliberately its own number rather than a
    /// slot on the type scale: this text is sized to a constraint (the drawer's
    /// width) rather than to a role.
    static const double _linkFontSize = 15;

    /// One tappable contact link — the Instagram handle, the email address.
    ///
    /// These are the two strings in the app that must never break across lines:
    /// half an email address is not an email address, and a handle wrapped after
    /// "bodnar__" reads as a different name. Three things enforce that
    /// together:
    ///
    /// * [TextScaler.noScaling] — the system font size does not apply here.
    ///   Everywhere else in the app it should, and does; an address is a piece
    ///   of data with a fixed shape, not prose, and at 2x it cannot fit any
    ///   phone's drawer.
    /// * `maxLines: 1` with `softWrap: false` — no wrapping, ever.
    /// * [BoxFit.scaleDown] — on a narrow drawer the whole string shrinks
    ///   instead of wrapping or ellipsising. `Instagram: @bodnar__mar…` would be
    ///   worse than small but complete: an address you cannot read in full is
    ///   an address you cannot use.
    ///
    /// The labels are the bare handle and address — no "Instagram:" or "Email:"
    /// prefix, because the icon beside them already says which is which, and at
    /// 15px the words were most of what had to fit.
    Widget _buildLinkTile({
        required Widget leading,
        required String label,
        required VoidCallback onTap,
    }) {
        return ListTile(
            leading: leading,
            title: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                        label,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.visible,
                        textScaler: TextScaler.noScaling,
                        style: AppText.titleSmall.copyWith(
                            fontSize: _linkFontSize,
                            color: AppColors.brand600,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.brand200,
                        ),
                    ),
                ),
            ),
            onTap: onTap,
        );
    }
}

/// Instagram's glyph, drawn rather than imported.
///
/// The camera icon it replaces was a generic camera — it said "photo", not
/// "Instagram", and next to a bare handle there was nothing left to identify
/// the service. Drawn with a [CustomPainter] instead of pulling in an icon
/// package (`font_awesome_flutter` is ~1.5MB of fonts) for the one glyph the
/// app needs, and it inherits [IconTheme] so it recolours with every other icon
/// in the list.
class _InstagramGlyph extends StatelessWidget {
    final double size;

    const _InstagramGlyph({this.size = 24});

    @override
    Widget build(BuildContext context) {
        final Color color = IconTheme.of(context).color ?? AppColors.n600;

        return SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
                painter: _InstagramPainter(color),
                isComplex: false,
            ),
        );
    }
}

class _InstagramPainter extends CustomPainter {
    final Color color;

    const _InstagramPainter(this.color);

    @override
    void paint(Canvas canvas, Size size) {
        final double s = size.shortestSide;
        // Matches the ~2dp weight of the Material icons it sits beside in the
        // contact list; anything lighter reads as a different icon set.
        final double stroke = s * 0.085;

        final Paint outline = Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = stroke
            ..strokeCap = StrokeCap.round;

        // The rounded square body.
        final double inset = stroke / 2 + s * 0.045;
        final double bodyWidth = s - inset * 2;
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTRB(inset, inset, s - inset, s - inset),
                Radius.circular(s * 0.25),
            ),
            outline,
        );

        // The lens, sized against the body's width rather than the icon's, so
        // the two shapes stay in proportion if the stroke is ever retuned (a
        // thinner stroke widens the body, and the lens follows). A shade under
        // a quarter: at exactly a quarter the ring crowds the body at 24px.
        canvas.drawCircle(Offset(s / 2, s / 2), bodyWidth / 4.4, outline);

        // The flash dot, up in the corner where the real mark carries it. It
        // keeps ~1.6dp of clear space from the corner arc at 24px; pushed much
        // further out it starts to merge with the body's stroke on a low-density
        // screen.
        canvas.drawCircle(
            Offset(s * 0.73, s * 0.27),
            s * 0.045,
            Paint()
                ..color = color
                ..style = PaintingStyle.fill,
        );
    }

    @override
    bool shouldRepaint(_InstagramPainter oldDelegate) =>
        oldDelegate.color != color;
}

/// "DEVELOPER · DEBUG" — the heading that fences off the debug-only tools.
class _DebugHeading extends StatelessWidget {
    const _DebugHeading();

    @override
    Widget build(BuildContext context) {
        return Row(
            children: <Widget>[
                Text(
                    'FEJLESZTŐI',
                    style: AppText.labelSmall.copyWith(color: AppColors.n400),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                        color: AppColors.warningSubtle,
                        borderRadius: AppRadius.all(AppRadius.xs),
                    ),
                    child: Text(
                        'DEBUG',
                        style: AppText.labelSmall.copyWith(
                            color: AppColors.warningText,
                        ),
                    ),
                ),
                const SizedBox(width: AppSpacing.md),
                const Expanded(child: Divider(height: 1)),
            ],
        );
    }
}
