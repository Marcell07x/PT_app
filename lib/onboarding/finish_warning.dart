import 'package:flutter/material.dart';
import 'package:getshap/common/bokeh_background.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/notifications/request_noti_permission.dart';
import 'package:getshap/common/pressable_button.dart';

class FinishWarning extends StatelessWidget {
    const FinishWarning({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
                extendBody: true,
                appBar: AppBar(
                    backgroundColor: Color.fromRGBO(22, 95, 239, 1),
                    title: Text(
                      AppLocalizations.of(context)!.important,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                      ),
                    ),
                ),
                body: BokehBackground(
                    child: Center(
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.red,
                                width: 4.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                            AppLocalizations.of(context)!.finishWarning,
                            style: const TextStyle(fontSize: 18.0, color: Colors.black87),
                        ),
                    ),
                ),
                ),
                bottomNavigationBar: SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child:  Pressable3DButton(
                                    color: const Color(0xFF2E6BF0),
                                    height: 58,
                                    onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => const RequestNotiPermission()),
                                        );
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.understand,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            ),
                                        ),
                                    ),

                    ),
                ),
            ),
        );
    }
}