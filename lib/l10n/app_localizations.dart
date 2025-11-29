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
  /// **'Wall Pushups'**
  String get wallPush;

  /// No description provided for @tablePush.
  ///
  /// In en, this message translates to:
  /// **'Table Pushups'**
  String get tablePush;

  /// No description provided for @kneePush.
  ///
  /// In en, this message translates to:
  /// **'Knee Pushups'**
  String get kneePush;

  /// No description provided for @pushUp.
  ///
  /// In en, this message translates to:
  /// **'Pushups'**
  String get pushUp;

  /// No description provided for @inclinePush.
  ///
  /// In en, this message translates to:
  /// **'Incline Pushups'**
  String get inclinePush;

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
  /// **'Jumping Squats'**
  String get squat3;

  /// No description provided for @lunge3.
  ///
  /// In en, this message translates to:
  /// **'Jumping Lunges'**
  String get lunge3;

  /// No description provided for @squat4.
  ///
  /// In en, this message translates to:
  /// **'Archer Squats'**
  String get squat4;

  /// No description provided for @lunge4.
  ///
  /// In en, this message translates to:
  /// **'Elevated Lunges'**
  String get lunge4;

  /// No description provided for @core1.
  ///
  /// In en, this message translates to:
  /// **'Situps'**
  String get core1;

  /// No description provided for @core2.
  ///
  /// In en, this message translates to:
  /// **'Supermans'**
  String get core2;

  /// No description provided for @workout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workout;

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
