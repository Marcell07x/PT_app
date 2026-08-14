import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Where the user stands relative to the current documents.
enum ConsentStatus {
    /// Never accepted anything: a fresh install, or one made before the
    /// consent screen existed (the `gaveConsent` key is simply absent).
    none,

    /// Accepted an earlier version of the documents. The text has changed
    /// materially since, so it has to be accepted again — the earlier
    /// acceptance does not cover the new terms.
    outdated,

    /// Accepted the version currently shipping.
    current,
}

/// Consent state plus the links to the published legal documents.
///
/// The gate is a stored flag, `gaveConsent`, together with the version that was
/// accepted. Nothing writes them until the user actually ticks the box on the
/// consent screen, so for everyone who installed the app before that screen
/// existed both keys are absent and the status comes back as [ConsentStatus.none].
/// Those users meet the screen once, on their next launch, before they can
/// reach the home screen — see `MyApp._firstScreen`.
class Legal {
    /// Version of the documents the user is accepting.
    ///
    /// **Bump this only when the documents change materially** — a new or wider
    /// liability limitation, a new obligation on the user, paid features, a
    /// change in what data is handled, a new health warning, a different
    /// governing law, or a change in who the contracting party is. Everyone who
    /// accepted an earlier version is then asked again on their next launch.
    ///
    /// Do **not** bump it for typos, clearer wording, formatting or a fixed
    /// link: those do not change what was agreed to, and re-prompting every
    /// user over them is noise that makes the prompt easier to dismiss
    /// unread the one time it matters.
    static const String documentVersion = '1.0';

    static const String _keyGaveConsent = 'gaveConsent';
    static const String _keyAcceptedAt = 'consentAcceptedAt';
    static const String _keyVersion = 'consentVersion';

    static const String _baseUrl = 'https://getshap.com';

    /// Reads the stored acceptance and compares it with [documentVersion].
    ///
    /// A stored flag without a version is treated as outdated rather than
    /// current: if it cannot be shown which text was accepted, the safe answer
    /// is to ask again.
    static Future<ConsentStatus> status() async {
        final prefs = await SharedPreferences.getInstance();

        final gaveConsent = prefs.getBool(_keyGaveConsent) ?? false;
        if (!gaveConsent) return ConsentStatus.none;

        final acceptedVersion = prefs.getString(_keyVersion);
        return acceptedVersion == documentVersion
            ? ConsentStatus.current
            : ConsentStatus.outdated;
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
