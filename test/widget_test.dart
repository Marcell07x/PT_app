// Smoke test for the app's very first frames: the splash renders, and once its
// timer elapses it hands over to the screen `MyApp._firstScreen` picked.
//
// This is deliberately the *routing* decision rather than any pixel detail, so
// the test survives a restyle but still fails if the launch path breaks.

import 'package:flutter_test/flutter_test.dart';

import 'package:getshap/main.dart';
import 'package:getshap/common/splash_screen.dart';
import 'package:getshap/core/legal.dart';
import 'package:getshap/onboarding/consent_page.dart';

void main() {
    testWidgets('a user who has not accepted the terms lands on the consent gate',
        (WidgetTester tester) async {
        await tester.pumpWidget(
            const MyApp(hasData: false, consent: ConsentStatus.none),
        );

        expect(find.byType(SplashScreen), findsOneWidget);

        // Let the splash's minDuration elapse, then run the fade transition.
        await tester.pump(const Duration(milliseconds: 1900));
        await tester.pumpAndSettle();

        expect(find.byType(ConsentPage), findsOneWidget);
        expect(find.byType(SplashScreen), findsNothing);
    });
}
