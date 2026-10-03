import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/notifications/schedule_noti.dart';
import 'package:getshap/main.dart';
import 'package:getshap/common/ui/app_button.dart';
import 'package:getshap/common/ui/app_scaffold.dart';
import 'package:getshap/theme/app_colors.dart';
import 'package:getshap/theme/app_spacing.dart';
import 'package:getshap/theme/app_typography.dart';

class RequestNotiPermission extends StatefulWidget {
    const RequestNotiPermission({super.key});

    @override
    State<RequestNotiPermission> createState() => _RequestNotiPermissionState();
}

class _RequestNotiPermissionState extends State<RequestNotiPermission> {
    final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
    bool _isPermissionGranted = false;

    @override
    void initState() {
        super.initState();
        _initializePermissionFlow();
    }

    Future<void> _goToHomePage() async {
        //clear the pending notifications first, even without permission, so
        //filling in the questionnaire again (debug) never leaves an older
        //chain behind. Best effort: if it throws or never returns, the user
        //still has to get to the home screen
        try {
            await ScheduleNotifications.cancelPending()
                .timeout(const Duration(seconds: 5));
        } catch (e) {
            debugPrint('cancelPending failed: $e');
        }
        if (!mounted) return;

        //then the "get started" nudge for the next day (skipped without
        //permission); it handles its own errors, so it is not awaited
        ScheduleNotifications.welcomeNoti(context);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const MyHomePage(),
            ),
            (Route<dynamic> route) => false,
        );
    }

    Future<void> _initializePermissionFlow() async {
        bool granted = await ScheduleNotifications.isNotificationGranted();
        setState(() {
            _isPermissionGranted = granted;
        });
        
        if (granted) {
            if (mounted) {
                _goToHomePage();
            }
        } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
                _requestNotificationPermission();
            });
        }
    }

    Future<void> _requestNotificationPermission() async {

        if (Platform.isAndroid) {
            if (_isPermissionGranted == false) {
                final androidPlugin = _notificationsPlugin
                    .resolvePlatformSpecificImplementation<
                        AndroidFlutterLocalNotificationsPlugin>();
                
                final bool? granted = await androidPlugin?.requestNotificationsPermission();
                
                setState(() {
                    _isPermissionGranted = granted == true;
                });
                
                if (granted == true) {
                    _goToHomePage();
                }
            } else {
                _goToHomePage();
            }
        }

        else if (Platform.isIOS) {
            if (_isPermissionGranted == false) {
                final iosPlugin = _notificationsPlugin
                    .resolvePlatformSpecificImplementation<
                        IOSFlutterLocalNotificationsPlugin>();
                
                final bool? granted = await iosPlugin?.requestPermissions(
                    alert: true,
                    badge: true,
                    sound: true,
                );
                
                setState(() {
                    _isPermissionGranted = granted == true;
                });
                
                if (granted == true) {
                    _goToHomePage();
                }
            } else {
                _goToHomePage();
            }
        }
    }

    @override
    Widget build(BuildContext context) {
        final AppLocalizations loc = AppLocalizations.of(context)!;

        return AppScaffold(
            title: loc.notis,
            // Reached by pushReplacement onto an already-cleared stack, so
            // there is no back destination.
            showBack: false,
            actions: [
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _goToHomePage,
                ),
            ],
            bottomBar: AppButton(
                label: loc.enableNotis,
                leadingIcon: Icons.notifications_active_outlined,
                onPressed: _requestNotificationPermission,
            ),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(
                            color: AppColors.brand50,
                            shape: BoxShape.circle,
                        ),
                        child: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.brand500,
                            size: 48,
                        ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                        loc.notisAreImportant,
                        textAlign: TextAlign.center,
                        style: AppText.headlineMedium.copyWith(color: AppColors.n900),
                    ),
                ],
            ),
        );
    }
}
