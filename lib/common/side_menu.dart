import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'l10n/app_localizations.dart';

class SideMenu extends StatelessWidget {
    final VoidCallback onSetLevelPressed;
    final VoidCallback onFormPressed;
    // The info page is shown inside this same drawer. The parent owns the
    // toggle so the Android back button can step Info -> menu -> home.
    final bool showInfo;
    final VoidCallback onShowInfoPressed;
    final VoidCallback onBackToMenuPressed;

    const SideMenu({
        super.key,
        required this.onSetLevelPressed,
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

    @override
    Widget build(BuildContext context) {
        // Calculate the width to be 80% of the screen
        final double menuWidth = MediaQuery.of(context).size.width * 0.8;
        // Calculate the top margin to start from the bottom of the AppBar
        final double topMargin = MediaQuery.of(context).padding.top + kToolbarHeight;

        return Container(
            width: menuWidth,
            margin: EdgeInsets.only(top: topMargin),
            child: Drawer(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                ),
                child: showInfo ? _buildInfoView(context) : _buildMenuView(context),
            ),
        );
    }

    Widget _buildMenuView(BuildContext context) {
        return ListView(
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
                        leading: const Icon(Icons.assignment),
                        title: Text(AppLocalizations.of(context)!.form),
                        onTap: onFormPressed,
                    ),
                ],
            ],
        );
    }

    Widget _buildInfoView(BuildContext context) {
        final loc = AppLocalizations.of(context)!;
        return ListView(
            padding: EdgeInsets.zero,
            children: [
                ListTile(
                    leading: const Icon(Icons.arrow_back),
                    title: Text(loc.goback),
                    onTap: onBackToMenuPressed,
                ),
                const Divider(height: 1),
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        loc.infoIntro,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                ),
                ListTile(
                    leading: const Icon(Icons.camera_alt_outlined),
                    title: Text(
                        loc.instagramLink,
                        style: const TextStyle(
                            color: Color.fromRGBO(22, 95, 239, 1),
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
                            color: Color.fromRGBO(22, 95, 239, 1),
                            decoration: TextDecoration.underline,
                        ),
                    ),
                    onTap: _openEmail,
                ),
            ],
        );
    }
}
