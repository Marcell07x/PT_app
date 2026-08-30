import 'package:flutter/material.dart';
import 'package:getshap/common/ui/app_button.dart';
import 'package:getshap/common/ui/app_card.dart';
import 'package:getshap/common/ui/app_scaffold.dart';
import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';
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

    /// True when the user already accepted an earlier version of the documents
    /// and is being asked again because they changed materially. The screen
    /// then leads with what happened, so a returning user is not left guessing
    /// why they are seeing this again.
    final bool isUpdate;

    const ConsentPage({
        super.key,
        required this.nextBuilder,
        this.isUpdate = false,
    });

    @override
    State<ConsentPage> createState() => _ConsentPageState();
}

class _ConsentPageState extends State<ConsentPage> {

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

        return AppScaffold(
            title: widget.isUpdate ? l.consentUpdatedTitle : l.consentTitle,
            centerScrollable: true,
            bottomBar: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    _buildCheckbox(l),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                        label: l.consentAccept,
                        onPressed: _accepted ? _accept : null,
                    ),
                ],
            ),
            body: _buildCard(l),
        );
    }

    /// The summary itself, deliberately kept to three points. The two that have
    /// to be here rather than behind a link are the risk being the user's own
    /// and the content not being professional advice: a term that departs from
    /// usual contractual practice only binds if attention was drawn to it and
    /// it was expressly accepted. Everything else lives in the documents.
    Widget _buildCard(AppLocalizations l) {
        return AppCard(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                    if (widget.isUpdate) ...[
                        _buildUpdateNotice(l),
                        const SizedBox(height: AppSpacing.xl),
                    ],
                    Text(
                        l.consentIntro,
                        style: AppText.bodyLarge.copyWith(color: AppColors.n900),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildPoint(l.consentPoint1),
                    _buildPoint(l.consentPoint2),
                    _buildPoint(l.consentPoint3),
                    const Divider(height: AppSpacing.xxxl),
                    _buildLink(l.consentTermsLink, Legal.termsUrl(context)),
                    _buildLink(l.consentHealthLink, Legal.healthUrl(context)),
                    _buildLink(l.consentPrivacyLink, Legal.privacyUrl(context)),
                ],
            ),
        );
    }

    /// Shown only on a re-acceptance: says plainly that the documents changed,
    /// so the returning user knows this is not the app repeating itself.
    Widget _buildUpdateNotice(AppLocalizations l) {
        return AppCard.notice(
            accent: AppColors.brand500,
            color: AppColors.brand50,
            icon: Icons.info_outline_rounded,
            child: Text(
                l.consentUpdatedBody,
                style: AppText.bodyMedium.copyWith(color: AppColors.n900),
            ),
        );
    }

    Widget _buildPoint(String text) {
        return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    const Padding(
                        padding: EdgeInsets.only(top: 5, right: AppSpacing.md),
                        child: Icon(Icons.circle, size: 7, color: AppColors.brand500),
                    ),
                    Expanded(
                        child: Text(
                            text,
                            style: AppText.bodyMedium.copyWith(color: AppColors.n600),
                        ),
                    ),
                ],
            ),
        );
    }

    Widget _buildLink(String label, String url) {
        return InkWell(
            onTap: () => Legal.open(url),
            borderRadius: AppRadius.all(AppRadius.xs),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                    children: [
                        const Icon(Icons.open_in_new, size: 16, color: AppColors.brand500),
                        const SizedBox(width: AppSpacing.sm),
                        Flexible(
                            child: Text(
                                label,
                                style: AppText.bodyMedium.copyWith(
                                    color: AppColors.brand500,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.brand500,
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
            borderRadius: AppRadius.all(AppRadius.sm),
            child: Container(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.md,
                ),
                decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.all(AppRadius.sm),
                    border: Border.all(color: AppColors.n200),
                ),
                child: Row(
                    children: [
                        Checkbox(
                            value: _accepted,
                            onChanged: (value) =>
                                setState(() => _accepted = value ?? false),
                        ),
                        Expanded(
                            child: Text(
                                l.consentCheckbox,
                                style: AppText.bodySmall.copyWith(color: AppColors.n900),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}
