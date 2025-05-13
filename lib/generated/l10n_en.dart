import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get onboardingTitle1 => 'Welcome to FireTrack360';

  @override
  String get onboardingDesc1 => 'Secure your world, one tap at a time';

  @override
  String get onboardingTitle2 => 'Get Started';

  @override
  String get onboardingDesc2 => 'Create an account or log in to access all features';

  @override
  String get onboardingTitle3 => 'Secure and Simple';

  @override
  String get onboardingDesc3 => 'Streamline your security management';

  @override
  String get register => 'Register';

  @override
  String get login => 'Login';

  @override
  String get dontHaveAccountPrompt => 'Don\'t have an account?';

  @override
  String get signUpLink => 'Sign Up';

  @override
  String get welcomeBackTitle => 'Welcome Back';

  @override
  String get signInToContinueSubtitle => 'Sign in to continue';

  @override
  String get fillAllFieldsError => 'Please fill in all fields';

  @override
  String get invalidEmailError => 'Please enter a valid email';

  @override
  String get loginFailedDefaultError => 'Login failed';

  @override
  String get emailVerificationRequiredError => 'Please verify your email before logging in';

  @override
  String get loginSuccessfulMessage => 'Login successful!';

  @override
  String get emailSaveFailedError => 'Failed to save email. Please try again.';

  @override
  String get unexpectedError => 'An unexpected error occurred';

  @override
  String get emailHintText => 'Email Address';

  @override
  String get passwordHintText => 'Password';

  @override
  String get forgotPasswordLink => 'Forgot Password?';
}
