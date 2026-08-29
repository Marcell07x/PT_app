import 'package:flutter/material.dart';

import 'package:getshap/common/ui/app_card.dart';
import 'package:getshap/common/ui/app_scaffold.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_typography.dart';

class TipDetailScreen extends StatelessWidget {
    final String tip;
    const TipDetailScreen({super.key, required this.tip});

    @override
    Widget build(BuildContext context) {
        final AppLocalizations l = AppLocalizations.of(context)!;

        return AppScaffold(
            title: l.tip,
            swipeToPop: true,
            centerScrollable: true,
            body: AppCard.section(
                eyebrow: l.tip,
                child: Text(
                    tip,
                    style: AppText.bodyLarge.copyWith(color: AppColors.n600),
                ),
            ),
        );
    }
}
