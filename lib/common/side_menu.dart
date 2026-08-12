import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:getshap/l10n/app_localizations.dart';

class SideMenu extends StatelessWidget {
    final VoidCallback onSetLevelPressed;
    final VoidCallback onAdvanceDayPressed;
    final VoidCallback onDumpStatePressed;
    final VoidCallback onFormPressed;
    // The info page is shown inside this same drawer. The parent owns the
    // toggle so the Android back button can step Info -> menu -> home.
    final bool showInfo;
    final VoidCallback onShowInfoPressed;
    final VoidCallback onBackToMenuPressed;

    const SideMenu({
        super.key,
        required this.onSetLevelPressed,
        required this.onAdvanceDayPressed,
        required this.onDumpStatePressed,
        required this.onFormPressed,
        required this.showInfo,
        required this.onShowInfoPressed,
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

    /// Shared blue used by the app bar and this menu.
    static const Color _blue = Color(0xFF2E6BF0);

    @override
    Widget build(BuildContext context) {
        final double menuWidth = MediaQuery.of(context).size.width * 0.7;

        // Full-height panel that reaches the top of the screen. Only the left
        // corners are rounded (the right edge is the screen edge); the drawer's
        // elevation casts a soft shadow onto the content for a subtle 3D edge,
        // echoing the floating app bar.
        return Drawer(
            width: menuWidth,
            backgroundColor: _blue,
            elevation: 12,
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    _buildHeader(context),
                    Expanded(
                        child: showInfo
                            ? _buildInfoView(context)
                            : _buildMenuView(context),
                    ),
                ],
            ),
        );
    }

    /// Branded header band at the top of the menu: the white logo mark and
    /// wordmark on the same blue sheen as the app bar, with a soft depth shadow
    /// separating it from the list below.
    Widget _buildHeader(BuildContext context) {
        final double topPad = MediaQuery.of(context).padding.top;
        final Color lighter = Color.lerp(_blue, Colors.white, 0.14)!;

        return Container(
            padding: EdgeInsets.fromLTRB(20, topPad + 18, 16, 18),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [lighter, _blue],
                ),
                boxShadow: const [
                    BoxShadow(
                        color: Color(0x40000000),
                        offset: Offset(0, 3),
                        blurRadius: 8,
                    ),
                ],
            ),
            child: Row(
                children: [
                    Image.asset(
                        'assets/icon/logo_mark.png',
                        width: 34,
                        height: 34,
                        filterQuality: FilterQuality.high,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                        'GetShap',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                        ),
                    ),
                ],
            ),
        );
    }

    Widget _buildMenuView(BuildContext context) {
        return ListTileTheme(
            iconColor: Colors.white,
            textColor: Colors.white,
            child: ListView(
            padding: EdgeInsets.zero,
            children: [
                ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(AppLocalizations.of(context)!.info),
                    onTap: onShowInfoPressed,
                ),
                // The menu is available in release mode but these options
                // are only visible when in debug mode.
                if (kDebugMode) ...[
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
                        title: const Text('Dump streak state'),
                        onTap: onDumpStatePressed,
                    ),
                    ListTile(
                        leading: const Icon(Icons.assignment),
                        title: Text(AppLocalizations.of(context)!.form),
                        onTap: onFormPressed,
                    ),
                ],
            ],
            ),
        );
    }

    Widget _buildInfoView(BuildContext context) {
        final loc = AppLocalizations.of(context)!;
        return ListTileTheme(
            iconColor: Colors.white,
            textColor: Colors.white,
            child: ListView(
            padding: EdgeInsets.zero,
            children: [
                ListTile(
                    leading: const Icon(Icons.arrow_back),
                    title: Text(loc.goback),
                    onTap: onBackToMenuPressed,
                ),
                const Divider(height: 1, color: Colors.white30),
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        loc.infoIntro,
                        style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.white),
                    ),
                ),
                ListTile(
                    leading: const Icon(Icons.camera_alt_outlined),
                    title: Text(
                        loc.instagramLink,
                        style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                        ),
                    ),
                    onTap: _openInstagram,
                ),
                ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: Text(
                        loc.emailLink,
                        style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                        ),
                    ),
                    onTap: _openEmail,
                ),
            ],
            ),
        );
    }
}
