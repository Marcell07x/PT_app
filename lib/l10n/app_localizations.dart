import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hu'),
  ];

  /// No description provided for @form.
  ///
  /// In en, this message translates to:
  /// **'Here is the form'**
  String get form;

  /// No description provided for @wallPush.
  ///
  /// In en, this message translates to:
  /// **'Wall Push Ups'**
  String get wallPush;

  /// No description provided for @tablePush.
  ///
  /// In en, this message translates to:
  /// **'Table Push Ups'**
  String get tablePush;

  /// No description provided for @kneePush.
  ///
  /// In en, this message translates to:
  /// **'Knee Push Ups'**
  String get kneePush;

  /// No description provided for @pushUp.
  ///
  /// In en, this message translates to:
  /// **'Pushups'**
  String get pushUp;

  /// No description provided for @declinePush.
  ///
  /// In en, this message translates to:
  /// **'Decline Push Ups'**
  String get declinePush;

  /// No description provided for @clapPush.
  ///
  /// In en, this message translates to:
  /// **'Explosive Clap Push Ups'**
  String get clapPush;

  /// No description provided for @archerPush.
  ///
  /// In en, this message translates to:
  /// **'Archer Push Ups'**
  String get archerPush;

  /// No description provided for @dipPush.
  ///
  /// In en, this message translates to:
  /// **'Dips'**
  String get dipPush;

  /// No description provided for @bagPull.
  ///
  /// In en, this message translates to:
  /// **'One Hand Bag Rows'**
  String get bagPull;

  /// No description provided for @bwPull.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight Rows'**
  String get bwPull;

  /// No description provided for @pullup.
  ///
  /// In en, this message translates to:
  /// **'Pullups'**
  String get pullup;

  /// No description provided for @squat1.
  ///
  /// In en, this message translates to:
  /// **'Assisted Squats'**
  String get squat1;

  /// No description provided for @lunge1.
  ///
  /// In en, this message translates to:
  /// **'Assisted Lunges'**
  String get lunge1;

  /// No description provided for @squat2.
  ///
  /// In en, this message translates to:
  /// **'Squats'**
  String get squat2;

  /// No description provided for @lunge2.
  ///
  /// In en, this message translates to:
  /// **'Lunges'**
  String get lunge2;

  /// No description provided for @squat3.
  ///
  /// In en, this message translates to:
  /// **'Backpack Squats'**
  String get squat3;

  /// No description provided for @lunge3.
  ///
  /// In en, this message translates to:
  /// **'Backpack Lunges'**
  String get lunge3;

  /// No description provided for @squat4.
  ///
  /// In en, this message translates to:
  /// **'Jumping Squats'**
  String get squat4;

  /// No description provided for @lunge4.
  ///
  /// In en, this message translates to:
  /// **'Elevated Lunges'**
  String get lunge4;

  /// No description provided for @squat5.
  ///
  /// In en, this message translates to:
  /// **'Archer Squats'**
  String get squat5;

  /// No description provided for @lunge5.
  ///
  /// In en, this message translates to:
  /// **'Weighted Elevated Lunges'**
  String get lunge5;

  /// No description provided for @core1.
  ///
  /// In en, this message translates to:
  /// **'Lying Leg Raises'**
  String get core1;

  /// No description provided for @core2.
  ///
  /// In en, this message translates to:
  /// **'Back Extensions'**
  String get core2;

  /// No description provided for @workout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workout;

  /// No description provided for @reps.
  ///
  /// In en, this message translates to:
  /// **'Repetitions'**
  String get reps;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @goback.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get goback;

  /// No description provided for @startWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start Workout'**
  String get startWorkout;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @nextq.
  ///
  /// In en, this message translates to:
  /// **'Next question'**
  String get nextq;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @mainGoal.
  ///
  /// In en, this message translates to:
  /// **'What\'s your main goal?'**
  String get mainGoal;

  /// No description provided for @weightLoss.
  ///
  /// In en, this message translates to:
  /// **'Weight Loss'**
  String get weightLoss;

  /// No description provided for @muscleBuild.
  ///
  /// In en, this message translates to:
  /// **'Building Muscle'**
  String get muscleBuild;

  /// No description provided for @maxKneePush.
  ///
  /// In en, this message translates to:
  /// **'How many knee pushups can you do?'**
  String get maxKneePush;

  /// No description provided for @maxSquats.
  ///
  /// In en, this message translates to:
  /// **'How many squats can you do?'**
  String get maxSquats;

  /// No description provided for @prevExp1.
  ///
  /// In en, this message translates to:
  /// **'Did you use to play sports regularly?'**
  String get prevExp1;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @prevExp2.
  ///
  /// In en, this message translates to:
  /// **'Have you tried to work out before?'**
  String get prevExp2;

  /// No description provided for @motivation.
  ///
  /// In en, this message translates to:
  /// **'How much are you motivated to work out?'**
  String get motivation;

  /// No description provided for @notAtAll.
  ///
  /// In en, this message translates to:
  /// **'Not at all'**
  String get notAtAll;

  /// No description provided for @somewhat.
  ///
  /// In en, this message translates to:
  /// **'I\'m somewhat motivated'**
  String get somewhat;

  /// No description provided for @motivated.
  ///
  /// In en, this message translates to:
  /// **'I\'m motivated'**
  String get motivated;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'What is your age group?'**
  String get age;

  /// No description provided for @congrat.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congrat;

  /// No description provided for @congratMessage.
  ///
  /// In en, this message translates to:
  /// **'Workout complete!'**
  String get congratMessage;

  /// No description provided for @rpe1.
  ///
  /// In en, this message translates to:
  /// **'Very Light Activity'**
  String get rpe1;

  /// No description provided for @rpe23.
  ///
  /// In en, this message translates to:
  /// **'Light Activity'**
  String get rpe23;

  /// No description provided for @rpe46.
  ///
  /// In en, this message translates to:
  /// **'Moderate Activity'**
  String get rpe46;

  /// No description provided for @rpe78.
  ///
  /// In en, this message translates to:
  /// **'Vigorous Activity'**
  String get rpe78;

  /// No description provided for @rpe910.
  ///
  /// In en, this message translates to:
  /// **'Very Intense Activity'**
  String get rpe910;

  /// No description provided for @howWasTheWorkout.
  ///
  /// In en, this message translates to:
  /// **'How hard was the workout?'**
  String get howWasTheWorkout;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @workoutReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick workout? 💪'**
  String get workoutReminderTitle;

  /// No description provided for @workoutReminderBody.
  ///
  /// In en, this message translates to:
  /// **'You\'re building a habit - keep going!'**
  String get workoutReminderBody;

  /// No description provided for @notis.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notis;

  /// No description provided for @notisAreImportant.
  ///
  /// In en, this message translates to:
  /// **'Notifications help you build the habit of working out.'**
  String get notisAreImportant;

  /// No description provided for @enableNotis.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotis;

  /// No description provided for @wallPushDesc.
  ///
  /// In en, this message translates to:
  /// **'Stand about one step away from the wall. Place your hands a bit wider than your shoulders, keep your elbows roughly 30-45 degrees from your body, and keep your body in a straight line. Go as close to the wall as you can, then push yourself back.'**
  String get wallPushDesc;

  /// No description provided for @tablePushDesc.
  ///
  /// In en, this message translates to:
  /// **'Place your hands on a stable table or bed, and a bit wider than your shoulders, keep your elbows roughly 30-45 degrees from your body, and keep your body in a straight line. Go as deep as you can, then push yourself up.'**
  String get tablePushDesc;

  /// No description provided for @kneePushDesc.
  ///
  /// In en, this message translates to:
  /// **'Kneel on something soft. Place your hands a bit wider than your shoulders, keep your elbows roughly 30-45 degrees from your body, and keep your body in a straight line. Go as deep as you can, then push yourself up.'**
  String get kneePushDesc;

  /// No description provided for @pushUpDesc.
  ///
  /// In en, this message translates to:
  /// **'Place your hands a bit wider than your shoulders, keep your elbows roughly 30-45 degrees from your body, and keep your body in a straight line. Go as deep as you can, then push yourself up.'**
  String get pushUpDesc;

  /// No description provided for @declinePushDesc.
  ///
  /// In en, this message translates to:
  /// **'Place your legs onto an elevated surface (like a bed) and your hands a bit wider than your shoulders. Keep your elbows roughly 30-45 degrees from your body, and keep your body in a straight line. Go as deep as you can, then push yourself up.'**
  String get declinePushDesc;

  /// No description provided for @clapPushDesc.
  ///
  /// In en, this message translates to:
  /// **'During a pushup, push yourself off the ground and, if you can, clap your hands while in mid-air.'**
  String get clapPushDesc;

  /// No description provided for @archerPushDesc.
  ///
  /// In en, this message translates to:
  /// **'Put your hands wide and rotate your palms out about 45 degrees. Bend one arm to lower yourself, keeping the other elbow slightly bent, then push back up. Do the same on the other side.'**
  String get archerPushDesc;

  /// No description provided for @dipPushDesc.
  ///
  /// In en, this message translates to:
  /// **'Hold the bars with the center of your palms on top. Keep your shoulders pressed down and maintain that position throughout. Lower yourself until your elbows reach at least a 90-degree bend, then push back up.'**
  String get dipPushDesc;

  /// No description provided for @bagPullDesc.
  ///
  /// In en, this message translates to:
  /// **'Fill a bag with books or small weights, aiming for at least 5–10 kg (11–22 lbs). Support yourself with one hand, keeping your torso straight and roughly horizontal. When you lower your hand, try to keep the bag off the ground. During the lift, keep your shoulders pressed down—don’t let them rise toward your ears. Don’t bend your arm more than 90°. If it feels too easy, increase the weight, lower it more slowly, or do more repetitions. Repeat on both sides.'**
  String get bagPullDesc;

  /// No description provided for @bwPullDesc.
  ///
  /// In en, this message translates to:
  /// **''**
  String get bwPullDesc;

  /// No description provided for @pullupDesc.
  ///
  /// In en, this message translates to:
  /// **''**
  String get pullupDesc;

  /// No description provided for @squat1Desc.
  ///
  /// In en, this message translates to:
  /// **'Hold onto something stable with one or both hands for support. Stand with your feet shoulder-width apart, toes slightly turned out. Start by pushing your knees slightly forward, then lower yourself in a controlled manner to about a 90° bend. Keep your torso straight throughout.'**
  String get squat1Desc;

  /// No description provided for @lunge1Desc.
  ///
  /// In en, this message translates to:
  /// **'Hold onto something stable with one or both hands for support. Step back, keeping your front shin vertical. Your thigh should point forward. Lean forward slightly so the focus is on the back of your front leg.'**
  String get lunge1Desc;

  /// No description provided for @squat2Desc.
  ///
  /// In en, this message translates to:
  /// **'Stand with your feet shoulder-width apart, toes slightly turned out. Start by pushing your knees slightly forward, then lower yourself in a controlled manner to about a 90° bend. Keep your torso straight throughout.'**
  String get squat2Desc;

  /// No description provided for @lunge2Desc.
  ///
  /// In en, this message translates to:
  /// **'Step back, keeping your front shin vertical. Your thigh should point forward. Lean forward slightly so the focus is on the back of your front leg.'**
  String get lunge2Desc;

  /// No description provided for @squat3Desc.
  ///
  /// In en, this message translates to:
  /// **'Fill a bag with books or other weights. Stand with your feet shoulder-width apart, toes slightly turned out. Start by pushing your knees slightly forward, then lower yourself in a controlled manner to about a 90° bend. Keep your torso straight throughout.'**
  String get squat3Desc;

  /// No description provided for @lunge3Desc.
  ///
  /// In en, this message translates to:
  /// **'Fill a bag with books or other weights. Step back, keeping your front shin vertical. Your thigh should point forward. Lean forward slightly so the focus is on the back of your front leg.'**
  String get lunge3Desc;

  /// No description provided for @squat4Desc.
  ///
  /// In en, this message translates to:
  /// **'Jump while doing a squat. Stand with your feet shoulder-width apart, toes slightly turned out. Start by pushing your knees slightly forward, then lower yourself in a controlled manner to about a 90° bend. Keep your torso straight throughout. If you want, wear a backpack filled with weights.'**
  String get squat4Desc;

  /// No description provided for @lunge4Desc.
  ///
  /// In en, this message translates to:
  /// **'Place your back leg on a chair. Keep your front shin vertical and your thigh pointing forward. Lean forward slightly so the weight is on the back of your front leg.'**
  String get lunge4Desc;

  /// No description provided for @squat5Desc.
  ///
  /// In en, this message translates to:
  /// **'Stand with your feet apart, toes slightly turned out. Start the descent by bending one knee. Keep your upper body as upright as possible.'**
  String get squat5Desc;

  /// No description provided for @lunge5Desc.
  ///
  /// In en, this message translates to:
  /// **'Fill a bag with books or other weights. Place your back leg on a chair. Keep your front shin vertical and your thigh pointing forward. Lean forward slightly so the weight is on the back of your front leg.'**
  String get lunge5Desc;

  /// No description provided for @core1Desc.
  ///
  /// In en, this message translates to:
  /// **'Place your hands under your hips and lift your head. Tighten your core and raise your legs, but not all the way vertical. Lower your legs in a controlled manner, keeping them off the ground between repetitions. Bending your knees makes it easier.'**
  String get core1Desc;

  /// No description provided for @core2Desc.
  ///
  /// In en, this message translates to:
  /// **'Lie face down on a chair and hold onto its legs. With your knees bent, lift your legs behind you as high as you can.'**
  String get core2Desc;

  /// No description provided for @lightBagPull.
  ///
  /// In en, this message translates to:
  /// **'One Hand Bag Rows with less weight'**
  String get lightBagPull;

  /// No description provided for @runInPlace.
  ///
  /// In en, this message translates to:
  /// **'Running In Place'**
  String get runInPlace;

  /// No description provided for @warmupDesc.
  ///
  /// In en, this message translates to:
  /// **'Perform the exercise in a controlled manner. Make sure to use proper form.'**
  String get warmupDesc;

  /// No description provided for @warmup.
  ///
  /// In en, this message translates to:
  /// **'Warmup'**
  String get warmup;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hu':
      return AppLocalizationsHu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
