// Renders every screen that can be built without a platform channel, at real
// phone dimensions, in both locales and at a large system font scale.
//
// `flutter_test` fails on any layout exception, so this catches the class of
// bug a redesign actually produces: RenderFlex overflows, unbounded
// constraints, content that no longer fits once the type scale changed.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:getshap/core/streak/streak_page.dart';
import 'package:getshap/l10n/app_localizations.dart';
import 'package:getshap/onboarding/consent_page.dart';
import 'package:getshap/onboarding/finish_warning.dart';
import 'package:getshap/onboarding/question_template.dart';
import 'package:getshap/theme/app_theme.dart';
import 'package:getshap/tips/tip_detail_screen.dart';
import 'package:getshap/workout/next_workout_page.dart';
import 'package:getshap/workout/workout_done_screen.dart';
import 'package:getshap/workout/workout_feedback.dart';

/// A long Hungarian string with ő/ű, so wrapping is exercised on real copy.
const String _huSample =
    'Mielőtt belevágsz, győződj meg róla, hogy a felület stabil, és hogy a '
    'gyakorlatot a saját felelősségedre végzed. A fekvőtámasz közben tartsd '
    'egyenesen a törzsed, és ne süllyeszd túl mélyre a vállad.';

void main() {
    setUp(() {
        SharedPreferences.setMockInitialValues(<String, Object>{
            'streak': 7,
            'streakFreeze': 1,
            'streakStartDate': 0,
            'streakFreezeDays': <String>[],
            'streakWorkoutDays': <String>[],
            'signal': false,
            'level': 42,
            'incspeed': 2,
            'lastWorkoutDate': 0,
            'workoutsThisWeek': 2,
        });
    });

    /// Wraps [child] in the real app shell: the real theme, the real
    /// localisations, one locale at a time.
    Widget host(Widget child, String locale) {
        return MaterialApp(
            theme: AppTheme.light(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale(locale),
            home: child,
        );
    }

    /// Pumps [child] on a phone-sized surface at [textScale] and settles it.
    Future<void> show(
        WidgetTester tester,
        Widget child,
        String locale, {
        double textScale = 1.0,
    }) async {
        tester.view.physicalSize = const Size(1080, 2340);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
            MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
                child: host(child, locale),
            ),
        );
        // Long enough for the streak animation's staged delays to run out.
        await tester.pump(const Duration(milliseconds: 900));
        await tester.pump(const Duration(milliseconds: 900));
    }

    final Map<String, Widget Function()> screens = <String, Widget Function()>{
        'consent': () => ConsentPage(
            nextBuilder: (_) => const SizedBox.shrink(),
        ),
        'consent (re-acceptance)': () => ConsentPage(
            nextBuilder: (_) => const SizedBox.shrink(),
            isUpdate: true,
        ),
        'questionnaire': () => QuestionTemplate(
            progressLabel: '3/7',
            title: 'Hány fekvőtámaszt tudsz megcsinálni térdről?',
            options: const <QuestionOption>[
                QuestionOption('0–15 között', 0),
                QuestionOption('15 fölött', 1),
            ],
            nextLabel: 'Tovább',
            onNext: (_, __) {},
        ),
        'health warning': () => const FinishWarning(),
        'tip detail': () => const TipDetailScreen(tip: _huSample),
        'rest day': () => const NextWorkoutPage(),
        'feedback': () => const WorkoutFeedback(),
        'congratulations': () => const CongratulationsScreen(),
        'streak': () => const StreakPage(),
    };

    for (final String locale in <String>['hu', 'en']) {
        for (final MapEntry<String, Widget Function()> entry in screens.entries) {
            testWidgets('[$locale] ${entry.key} renders', (WidgetTester tester) async {
                await show(tester, entry.value(), locale);
                expect(tester.takeException(), isNull);
            });
        }
    }

    // The screens most likely to overflow once the type scale grows: the ones
    // with a fixed-height card or a bottom-pinned button.
    for (final String name in <String>[
        'consent',
        'questionnaire',
        'health warning',
        'feedback',
    ]) {
        testWidgets('[hu] $name survives a 1.3x system font',
            (WidgetTester tester) async {
            await show(tester, screens[name]!(), 'hu', textScale: 1.3);
            expect(tester.takeException(), isNull);
        });
    }
}
