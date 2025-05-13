import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_fr.dart';
import 'l10n_rw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
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
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('rw')
  ];

  /// Title for first onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to FireTrack360'**
  String get onboardingTitle1;

  /// Description for first onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Secure your world, one tap at a time'**
  String get onboardingDesc1;

  /// Title for second onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingTitle2;

  /// Description for second onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Create an account or log in to access all features'**
  String get onboardingDesc2;

  /// Title for third onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Secure and Simple'**
  String get onboardingTitle3;

  /// Description for third onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Streamline your security management'**
  String get onboardingDesc3;

  /// Text for register button
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Text for login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Prompt for users without an account on the login page
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccountPrompt;

  /// Text for the sign up link on the login page
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpLink;

  /// Main title on the login header
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBackTitle;

  /// Subtitle prompting the user to sign in on the login header
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinueSubtitle;

  /// Error message when not all login fields are filled
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get fillAllFieldsError;

  /// Error message for an invalid email format during login
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmailError;

  /// Default error message when login fails without a specific message from the server
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailedDefaultError;

  /// Error message when a user tries to log in with an unverified email
  ///
  /// In en, this message translates to:
  /// **'Please verify your email before logging in'**
  String get emailVerificationRequiredError;

  /// Success message after a successful login
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessfulMessage;

  /// Error message when saving the user's email to SharedPreferences fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save email. Please try again.'**
  String get emailSaveFailedError;

  /// Generic error message for unexpected issues
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// Hint text for the email input field on the login form
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailHintText;

  /// Hint text for the password input field on the login form
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHintText;

  /// Text for the 'Forgot Password?' link on the login form
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordLink;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr', 'rw'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return SEn();
    case 'fr': return SFr();
    case 'rw': return SRw();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
