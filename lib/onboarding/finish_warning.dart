import 'package:flutter/material.dart';

import 'package:getshap/common/ui/app_button.dart';
import 'package:getshap/common/ui/app_card.dart';
import 'package:getshap/common/ui/app_scaffold.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/notifications/request_noti_permission.dart';
import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_typography.dart';

class FinishWarning extends StatelessWidget {
    const FinishWarning({super.key});

    @override
    Widget build(BuildContext context) {
        final AppLocalizations loc = AppLocalizations.of(context)!;

        return AppScaffold(
            title: loc.important,
            centerScrollable: true,
            // The questionnaire clears the stack before pushing this screen, so
            // there is nothing to go back to. Pinned explicitly rather than
            // relying on that, now that this Scaffold sits on the root
            // Navigator.
            showBack: false,
            bottomBar: AppButton(
                label: loc.understand,
                onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                            builder: (context) => const RequestNotiPermission(),
                        ),
                    );
                },
            ),
            // Warning rather than danger. `AppColors.danger` is documented as
            // the health-warning colour, and this is an instruction about how
            // to use a button — spending red here makes it mean less on the
            // screen where it is about someone's body.
            // The shield read as "health and safety", which is the wrong
            // promise: nothing here is about getting hurt. A triangle with an
            // exclamation mark is the one glyph everybody already reads as
            // "pay attention to this bit", and it is `_rounded` to match the
            // other icons the app uses.
            body: AppCard.notice(
                accent: AppColors.warning,
                color: AppColors.warningSubtle,
                icon: Icons.warning_amber_rounded,
                child: Text(
                    loc.finishWarning,
                    style: AppText.bodyLarge.copyWith(color: AppColors.n900),
                ),
            ),
        );
    }
}
