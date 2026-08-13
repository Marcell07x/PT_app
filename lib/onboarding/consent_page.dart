import 'package:flutter/material.dart';
import 'package:getshap/common/bokeh_background.dart';
import 'package:getshap/common/pressable_button.dart';
import 'package:getshap/core/legal.dart';
import 'package:getshap/l10n/app_localizations.dart';

/// The consent gate: a short summary of what the user is agreeing to, links to
/// the full documents, and a checkbox that has to be ticked before the button
/// unlocks.
///
/// It is the first thing shown after the splash, ahead of the questionnaire,
/// so that nothing the user does in the app — including trying an exercise to
/// answer a question — happens before the warning. Where it continues to
/// afterwards differs (questionnaire for new users, home screen for existing
/// ones), so it takes that as a parameter and clears the stack behind it.
class ConsentPage extends StatefulWidget {
    /// Builds the screen shown once consent has been given.
    final WidgetBuilder nextBuilder;

    const ConsentPage({super.key, required this.nextBuilder});

    @override
    State<ConsentPage> createState() => _ConsentPageState();
}

class _ConsentPageState extends State<ConsentPage> {
    static const Color _blue = Color(0xFF2E6BF0);

    bool _accepted = false;
    // Guards against a double tap pushing the next screen twice while the
    // preference write is still in flight.
    bool _saving = false;

    Future<void> _accept() async {
        if (_saving) return;
        setState(() => _saving = true);

        await Legal.saveConsent();
        if (!mounted) return;

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: widget.nextBuilder),
            (route) => false,
        );
    }

    @override
    Widget build(BuildContext context) {
        final l = AppLocalizations.of(context)!;

        return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
                appBar: AppBar(
                    backgroundColor: _blue,
                    foregroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    title: Text(
                        l.consentTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                ),
                body: BokehBackground(
                    child: SafeArea(
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                    // Vertically centred in the free space, and
                                    // scrollable when it cannot fit (small
                                    // screens, large system font).
                                    Expanded(
                                        child: LayoutBuilder(
                                            builder: (context, constraints) => SingleChildScrollView(
                                                child: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        minHeight: constraints.maxHeight,
                                                    ),
                                                    child: Center(child: _buildCard(l)),
                                                ),
                                            ),
                                        ),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildCheckbox(l),
                                    const SizedBox(height: 12),
                                    Pressable3DButton(
                                        color: _blue,
                                        height: 58,
                                        onPressed: _accepted ? _accept : null,
                                        child: Text(
                                            l.consentAccept,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ),
                ),
            ),
        );
    }

    /// The summary itself, deliberately kept to three points. The two that have
    /// to be here rather than behind a link are the risk being the user's own
    /// and the content not being professional advice: a term that departs from
    /// usual contractual practice only binds if attention was drawn to it and
    /// it was expressly accepted. Everything else lives in the documents.
    Widget _buildCard(AppLocalizations l) {
        return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                    Text(
                        l.consentIntro,
                        style: const TextStyle(
                            fontSize: 16,
                            height: 1.4,
                            color: Colors.black87,
                        ),
                    ),
                    const SizedBox(height: 16),
                    _buildPoint(l.consentPoint1),
                    _buildPoint(l.consentPoint2),
                    _buildPoint(l.consentPoint3),
                    const Divider(height: 28),
                    _buildLink(l.consentTermsLink, Legal.termsUrl(context)),
                    _buildLink(l.consentHealthLink, Legal.healthUrl(context)),
                    _buildLink(l.consentPrivacyLink, Legal.privacyUrl(context)),
                ],
            ),
        );
    }

    Widget _buildPoint(String text) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    const Padding(
                        padding: EdgeInsets.only(top: 3, right: 10),
                        child: Icon(Icons.circle, size: 8, color: _blue),
                    ),
                    Expanded(
                        child: Text(
                            text,
                            style: const TextStyle(
                                fontSize: 15,
                                height: 1.35,
                                color: Colors.black87,
                            ),
                        ),
                    ),
                ],
            ),
        );
    }

    Widget _buildLink(String label, String url) {
        return InkWell(
            onTap: () => Legal.open(url),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                    children: [
                        const Icon(Icons.open_in_new, size: 16, color: _blue),
                        const SizedBox(width: 8),
                        Flexible(
                            child: Text(
                                label,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: _blue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: _blue,
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    /// Deliberately starts unticked: consent only counts if the user actively
    /// gives it. Tapping the text toggles it too, so the tap target is not
    /// just the small box.
    Widget _buildCheckbox(AppLocalizations l) {
        return InkWell(
            onTap: () => setState(() => _accepted = !_accepted),
            borderRadius: BorderRadius.circular(12),
            child: Container(
                padding: const EdgeInsets.fromLTRB(8, 10, 14, 10),
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Checkbox(
                            value: _accepted,
                            activeColor: _blue,
                            onChanged: (value) =>
                                setState(() => _accepted = value ?? false),
                        ),
                        Expanded(
                            child: Text(
                                l.consentCheckbox,
                                style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.3,
                                    color: Colors.black87,
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}
