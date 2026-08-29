// Guards for the app's navigation shell.
//
// Six screens used to wrap themselves in their own MaterialApp, which reset the
// theme and installed a second, inert Navigator mid-tree. They have been
// un-nested; these tests keep them that way.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/workout/workout_feedback.dart';

void main() {
    test('main.dart is the only place that constructs a MaterialApp', () {
        // A source-level check rather than a widget test: several of the
        // formerly-nested screens (video player, notification permissions) need
        // platform channels to build, and the constraint being protected here is
        // architectural, not visual.
        final List<String> offenders = <String>[];

        for (final FileSystemEntity entity in Directory('lib').listSync(recursive: true)) {
            if (entity is! File || !entity.path.endsWith('.dart')) continue;

            final String path = entity.path.replaceAll(r'\', '/');
            // main.dart owns the one real app shell; the l10n files are
            // generated and only mention MaterialApp in a doc comment.
            if (path.endsWith('lib/main.dart') || path.contains('/l10n/')) continue;

            if (entity.readAsStringSync().contains('MaterialApp(')) {
                offenders.add(path);
            }
        }

        expect(
            offenders,
            isEmpty,
            reason: 'A nested MaterialApp resets ThemeData and inserts a second '
                'Navigator, so the app theme stops reaching the screen. Use a '
                'plain Scaffold instead.',
        );
    });

    testWidgets('the feedback screen still blocks the system back button',
        (WidgetTester tester) async {
        // The default 800x600 test surface is wider and much shorter than any
        // phone; the feedback screen's column overflows on it.
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

        await tester.pumpWidget(
            MaterialApp(
                navigatorKey: navigator,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: const Scaffold(body: Text('behind')),
            ),
        );

        navigator.currentState!.push(
            MaterialPageRoute<void>(builder: (_) => const WorkoutFeedback()),
        );
        await tester.pumpAndSettle();
        expect(find.byType(WorkoutFeedback), findsOneWidget);

        // Android's hardware back button arrives as a popRoute platform message.
        await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
            'flutter/navigation',
            const JSONMethodCodec().encodeMethodCall(const MethodCall('popRoute')),
            (ByteData? _) {},
        );
        await tester.pumpAndSettle();

        // PopScope(canPop: false) must keep the user on the feedback screen.
        expect(find.byType(WorkoutFeedback), findsOneWidget);
        expect(find.text('behind'), findsNothing);
    });
}
