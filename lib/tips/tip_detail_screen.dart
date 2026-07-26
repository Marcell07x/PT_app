import 'package:flutter/material.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/common/bokeh_background.dart';

class TipDetailScreen extends StatelessWidget {
    final String tip;
    const TipDetailScreen({super.key, required this.tip});

    @override
    Widget build(BuildContext context) {
        final l = AppLocalizations.of(context)!;
        return GestureDetector(
            // Swipe left-to-right from anywhere to go back to the home page.
            onHorizontalDragEnd: (details) {
                if ((details.primaryVelocity ?? 0) > 250) {
                    Navigator.of(context).pop();
                }
            },
            child: Scaffold(
            appBar: AppBar(
                backgroundColor: const Color(0xFF2E6BF0),
                foregroundColor: Colors.white,
                title: Text(l.tip),
            ),
            body: BokehBackground(
                child: SafeArea(
                    child: LayoutBuilder(
                        builder: (context, constraints) => SingleChildScrollView(
                            child: ConstrainedBox(
                                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                                child: Center(
                                    child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(18),
                                                boxShadow: const [
                                                    BoxShadow(
                                                        color: Color(0x59000000),
                                                        blurRadius: 22,
                                                        offset: Offset(0, 10),
                                                    ),
                                                ],
                                            ),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                    Padding(
                                                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                                                        child: Text(
                                                            l.tip.toUpperCase(),
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight.w800,
                                                                color: Color(0xFF16408C),
                                                                fontSize: 17,
                                                                letterSpacing: 0.5,
                                                            ),
                                                        ),
                                                    ),
                                                    Container(height: 1, color: const Color(0x1A16408C)),
                                                    Padding(
                                                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
                                                        child: Text(
                                                            tip,
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                height: 1.5,
                                                                color: Color(0xFF3A3F52),
                                                            ),
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        ),
                                    ),
                                ),
                            ),
                        ),
                    ),
                ),
            ),
        ),
        );
    }
}
