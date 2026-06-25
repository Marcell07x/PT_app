import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'l10n/app_localizations.dart';

class SideMenu extends StatelessWidget {
    final VoidCallback onSetLevelPressed;
    final VoidCallback onFormPressed;

    const SideMenu({
        super.key,
        required this.onSetLevelPressed,
        required this.onFormPressed,
    });

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
                child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
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
                ),
            ),
        );
    }
}
