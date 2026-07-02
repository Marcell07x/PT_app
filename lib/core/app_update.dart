import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

import 'package:getshap/l10n/app_localizations.dart';

/// Checks the Google Play Store for a newer version of the app and, if one is
/// available, downloads it in the background (the Play "flexible" update flow).
///
/// No backend or cloud service is required: this talks directly to the Play
/// Store through the Play In-App Updates API. It only does anything on Android;
/// on every other platform the call returns immediately.
///
/// Flexible flow, step by step:
///   1. Ask Play whether a newer version exists.
///   2. If yes, start downloading it in the background while the user keeps
///      using the app as normal.
///   3. When the download finishes, show a SnackBar asking the user to restart.
///      Tapping "Restart" installs the update and relaunches the app.
///
/// If the user ignores the SnackBar, the downloaded update is installed
/// automatically the next time they fully close and reopen the app.
class AppUpdater {
  // Guards against running the check more than once per app process (e.g. if
  // the home screen is rebuilt or re-entered).
  static bool _alreadyChecked = false;

  static Future<void> checkForFlexibleUpdate(BuildContext context) async {
    // In-app updates are a Google Play feature; skip everything else.
    if (!Platform.isAndroid) return;
    if (_alreadyChecked) return;
    _alreadyChecked = true;

    try {
      final info = await InAppUpdate.checkForUpdate();

      final canUpdate =
          info.updateAvailability == UpdateAvailability.updateAvailable &&
          info.flexibleUpdateAllowed;
      if (!canUpdate) return;

      // Downloads in the background. Completes with success once the download
      // (not the install) has finished.
      final result = await InAppUpdate.startFlexibleUpdate();
      if (result != AppUpdateResult.success) return;

      // The download is ready; prompt the user to restart to install it.
      if (!context.mounted) return;
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.updateReadyMessage),
          // Keep it visible until the user acts on it.
          duration: const Duration(days: 1),
          action: SnackBarAction(
            label: l.updateRestart,
            onPressed: () {
              // Installs the update and restarts the app.
              InAppUpdate.completeFlexibleUpdate();
            },
          ),
        ),
      );
    } catch (e) {
      // checkForUpdate throws when the app was not installed from Play (debug
      // builds, sideloaded APKs, emulators without Play Services, etc.).
      // There is nothing to update in those cases, so it is safe to ignore.
      if (kDebugMode) debugPrint('In-app update check skipped: $e');
    }
  }
}
