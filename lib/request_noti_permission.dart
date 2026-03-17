import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'l10n/app_localizations.dart';
import 'main.dart';

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

    void _goToHomePage() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const MyApp(),
            ),
            (Route<dynamic> route) => false,
        );
    }

    Future<void> _initializePermissionFlow() async {
        bool granted = await isNotificationGranted();
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
        print(_isPermissionGranted);
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
    }

    Future<bool> isNotificationGranted() async {
        if (Platform.isAndroid) {
            final androidPlugin = _notificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>();
            
            if (androidPlugin == null) return false;
            
            final bool? granted = await androidPlugin.areNotificationsEnabled();
            return granted == true;
        }
        return false;
    }

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
                appBar: AppBar(
                    title: Text(AppLocalizations.of(context)!.notis),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    actions: [
                        IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                                _goToHomePage();
                            },
                        ),
                    ]
                ),
                body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        children: [
                            Expanded(
                                child: Center(
                                    child: Padding(
                                        padding: const EdgeInsets.only(bottom: 150),
                                        child: Text(
                                            AppLocalizations.of(context)!.notisAreImportant,
                                            style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center, 
                                        ),
                                    ),
                                ),
                            ),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () {
                                        _requestNotificationPermission();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: Text(
                                        AppLocalizations.of(context)!.enableNotis,
                                        style: TextStyle(fontSize: 18),
                                    ),
                                ),
                            ),
                            const SizedBox(height: 40),
                        ],  
                        
                    ),
                ),
            ),
        );
    }
}
