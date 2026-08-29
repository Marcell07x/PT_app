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

        // Full-height brand-blue panel reaching the top of the screen. Only the
        // left corners are rounded (the right edge is the screen edge); the
        // elevation casts a soft shadow onto the light page behind it.
        //
        // The drawer stays saturated blue while the pages behind it are light:
        // it is chrome, like the app bar and the splash, and it is the one
        // other place the white logo mark appears.
        return Drawer(
            width: menuWidth,
            backgroundColor: AppColors.brand500,
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

    /// Branded header band: the white logo mark and wordmark, separated from
    /// the list below by a hairline rather than the old drop shadow.
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
                border: Border(
                    bottom: BorderSide(color: Color(0x33FFFFFF)),
                ),
            ),
            child: Row(
                children: [
                    Image.asset(
                        'assets/icon/logo_mark.png',
                        width: 32,
                        height: 32,
                        filterQuality: FilterQuality.high,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                        'GetShap',
                        style: AppText.titleLarge.copyWith(
                            color: AppColors.onBrand,
                            letterSpacing: 0.3,
                        ),
                    ),
                ],
            ),
        );
    }

    /// Shared chrome for both pages of the menu: white text and icons on the
    /// blue panel, with a consistent row shape.
    Widget _menuList({required List<Widget> children}) {
        return ListTileTheme(
            data: ListTileThemeData(
                iconColor: AppColors.onBrand,
                textColor: AppColors.onBrand,
                titleTextStyle: AppText.titleSmall.copyWith(
                    color: AppColors.onBrand,
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
                // are only visible when in debug mode.
                if (kDebugMode) ...[
                    const Divider(height: AppSpacing.xxl, color: Color(0x33FFFFFF)),
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
                const Divider(height: 1, color: Color(0x33FFFFFF)),
                Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        AppSpacing.xl,
                        AppSpacing.xl,
                        AppSpacing.md,
                    ),
                    child: Text(
                        loc.infoIntro,
                        style: AppText.bodyMedium.copyWith(color: AppColors.onBrand),
                    ),
                ),
                _buildLinkTile(
                    icon: Icons.camera_alt_outlined,
                    label: loc.instagramLink,
                    onTap: _openInstagram,
                ),
                _buildLinkTile(
                    icon: Icons.email_outlined,
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

    Widget _buildLinkTile({
        required IconData icon,
        required String label,
        required VoidCallback onTap,
    }) {
        return ListTile(
            leading: Icon(icon),
            title: Text(
                label,
                style: AppText.titleSmall.copyWith(
                    color: AppColors.onBrand,
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0x99FFFFFF),
                ),
            ),
            onTap: onTap,
        );
    }
}
