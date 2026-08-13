import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Consent state plus the links to the published legal documents.
///
/// The gate is a single stored flag, `gaveConsent`. Nothing writes it until the
/// user actually ticks the box on the consent screen, so for everyone who
/// installed the app before that screen existed the key is simply absent and
/// reading it falls back to false. Those users therefore meet the screen once,
/// on their next launch, before they can reach the home screen — see
/// `MyApp._firstScreen`.
class Legal {
    /// Version of the documents the user is accepting. Bump this when the
    /// documents change materially; the accepted version is stored alongside
    /// the flag, so it stays clear afterwards who agreed to which text.
    static const String documentVersion = '1.0';

    static const String _keyGaveConsent = 'gaveConsent';
    static const String _keyAcceptedAt = 'consentAcceptedAt';
    static const String _keyVersion = 'consentVersion';

    static const String _baseUrl = 'https://getshap.com';

    /// False both when the user has declined so far and when the key has never
    /// been written (every pre-existing install).
    static Future<bool> hasGivenConsent() async {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getBool(_keyGaveConsent) ?? false;
    }

    /// Records the acceptance. The timestamp and version are written next to
    /// the flag as the actual record of consent — the flag alone only says
    /// "yes at some point", which is worth much less if it is ever questioned.
    static Future<void> saveConsent() async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_keyGaveConsent, true);
        await prefs.setString(_keyAcceptedAt, DateTime.now().toIso8601String());
        await prefs.setString(_keyVersion, documentVersion);
    }

    // The documents are published in both languages; the device locale decides
    // which one opens. Anything that is not Hungarian gets the English text.
    static String _path(BuildContext context, String hu, String en) =>
        Localizations.localeOf(context).languageCode == 'hu' ? hu : en;

    static String termsUrl(BuildContext context) =>
        '$_baseUrl${_path(context, '/hu/feltetelek', '/terms')}';

    static String healthUrl(BuildContext context) =>
        '$_baseUrl${_path(context, '/hu/egeszseg', '/health')}';

    static String privacyUrl(BuildContext context) =>
        '$_baseUrl${_path(context, '/hu/adatvedelem', '/privacy')}';

    /// Opens a document in the browser. Failures are swallowed on purpose: no
    /// browser, or no network, must not be able to block the consent screen.
    static Future<void> open(String url) async {
        try {
            await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } catch (e) {
            if (kDebugMode) debugPrint('Could not open $url: $e');
        }
    }
}
