import 'dart:convert' show jsonDecode, utf8;
import 'dart:io' show HttpClient, Platform;

import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:getshap/l10n/app_localizations.dart';

/// Checks whether a newer version of the app is available and prompts the user
/// to update. The mechanism is completely different on each platform, because
/// Android and iOS offer very different capabilities:
///
///   * Android (Google Play): uses the Play "flexible" in-app update flow. The
///     newer version is downloaded in the background while the user keeps using
///     the app, then a SnackBar offers to restart and install it. No backend or
///     App Store page is involved.
///
///   * iOS (App Store): Apple provides no in-app update API — an app cannot
///     download or install its own update. Instead we ask Apple's public iTunes
///     lookup service what the latest App Store version is, compare it with the
///     running version, and if it is newer show a dialog that sends the user to
///     the App Store to update manually.
///
/// On every other platform the call returns immediately.
class AppUpdater {
  // Guards against running the check more than once per app process (e.g. if
  // the home screen is rebuilt or re-entered).
  static bool _alreadyChecked = false;

  // The iOS bundle identifier, used to look the app up in the App Store.
  static const String _iosBundleId = 'app.bodnarm.getshap';

  /// Entry point: dispatches to the platform-appropriate update check.
  static Future<void> checkForUpdate(BuildContext context) async {
    if (_alreadyChecked) return;
    _alreadyChecked = true;

    if (Platform.isAndroid) {
      await _checkAndroid(context);
    } else if (Platform.isIOS) {
      await _checkIos(context);
    }
  }

  // Kept for backwards compatibility with existing callers.
  static Future<void> checkForFlexibleUpdate(BuildContext context) =>
      checkForUpdate(context);

  // ---------------------------------------------------------------------------
  // Android: Google Play flexible in-app update
  // ---------------------------------------------------------------------------
  //
  // Step by step:
  //   1. Ask Play whether a newer version exists.
  //   2. If yes, download it in the background while the user keeps using the
  //      app as normal.
  //   3. When the download finishes, show a SnackBar asking the user to restart.
  //      Tapping "Restart" installs the update and relaunches the app.
  //
  // If the user ignores the SnackBar, the downloaded update is installed
  // automatically the next time they fully close and reopen the app.
  static Future<void> _checkAndroid(BuildContext context) async {
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

  // ---------------------------------------------------------------------------
  // iOS: App Store version check
  // ---------------------------------------------------------------------------
  //
  // Step by step:
  //   1. Read the version currently running on the device.
  //   2. Ask Apple's iTunes lookup service for the latest App Store version.
  //   3. If the App Store version is newer, show a dialog whose button opens the
  //      App Store page so the user can update manually.
  static Future<void> _checkIos(BuildContext context) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version; // e.g. "1.2.0"

      // Query the store for the user's region (that is where they would update).
      final country = _deviceCountryCode();
      final uri = Uri.https('itunes.apple.com', '/lookup', {
        'bundleId': _iosBundleId,
        'country': ?country,
      });

      final json = await _getJson(uri);
      if (json == null) return;

      final results = json['results'];
      if (results is! List || results.isEmpty) return;
      final app = results.first as Map<String, dynamic>;

      final storeVersion = app['version'] as String?;
      final trackId = app['trackId'];
      if (storeVersion == null || trackId == null) return;

      // Only prompt when the store genuinely has a newer version.
      if (!_isNewer(storeVersion, currentVersion)) return;

      // Deep link that opens the App Store app straight on this app's page.
      final storeUrl = Uri.parse('https://apps.apple.com/app/id$trackId');

      if (!context.mounted) return;
      final l = AppLocalizations.of(context)!;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l.updateAvailableTitle),
          content: Text(l.updateAvailableMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l.updateLater),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                launchUrl(storeUrl, mode: LaunchMode.externalApplication);
              },
              child: Text(l.updateNow),
            ),
          ],
        ),
      );
    } catch (e) {
      // No network, app not yet on the store, unexpected response shape, etc.
      // None of these are worth bothering the user about.
      if (kDebugMode) debugPrint('iOS update check skipped: $e');
    }
  }

  // Fetches [uri] and decodes the body as JSON, or returns null on any failure.
  static Future<Map<String, dynamic>?> _getJson(Uri uri) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(uri);
      final response = await request.close();
      if (response.statusCode != 200) return null;
      final body = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : null;
    } finally {
      client.close();
    }
  }

  // Extracts a two-letter country code from the device locale (e.g. "hu_HU" ->
  // "hu"), so the lookup hits the same regional store the user updates from.
  static String? _deviceCountryCode() {
    final locale = Platform.localeName; // e.g. "hu_HU" or "en_US.UTF-8"
    final match = RegExp(r'_([A-Za-z]{2})').firstMatch(locale);
    return match?.group(1)?.toLowerCase();
  }

  // Returns true when [candidate] is a strictly higher version than [current].
  // Compares dotted numeric versions component by component ("1.2.10" > "1.2.9").
  static bool _isNewer(String candidate, String current) {
    List<int> parts(String v) => v
        .split('.')
        .map((p) => int.tryParse(p.trim()) ?? 0)
        .toList();

    final a = parts(candidate);
    final b = parts(current);
    final length = a.length > b.length ? a.length : b.length;
    for (var i = 0; i < length; i++) {
      final x = i < a.length ? a[i] : 0;
      final y = i < b.length ? b[i] : 0;
      if (x != y) return x > y;
    }
    return false;
  }
}
