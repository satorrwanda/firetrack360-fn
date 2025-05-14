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

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get signUpToGetStartedSubtitle => 'Sign up to get started';

  @override
  String get enterPhoneNumberError => 'Please enter your phone number';

  @override
  String get rwandaPhoneNumberLengthError => 'Rwanda phone numbers must be 9 digits';

  @override
  String get rwandaPhoneNumberStartError => 'Rwanda phone numbers must start with 7';

  @override
  String get phoneNumberMinLengthError => 'Phone number must be at least 9 digits';

  @override
  String get phoneNumberMaxLengthError => 'Phone number cannot exceed 10 digits';

  @override
  String get enterPasswordError => 'Please enter a password';

  @override
  String get passwordMinLengthError => 'Password must be at least 8 characters long';

  @override
  String get passwordUppercaseError => 'Password must contain at least one uppercase letter';

  @override
  String get passwordLowercaseError => 'Password must contain at least one lowercase letter';

  @override
  String get passwordDigitError => 'Password must contain at least one number';

  @override
  String get passwordSpecialCharError => 'Password must contain at least one special character';

  @override
  String get confirmPasswordError => 'Please confirm your password';

  @override
  String get passwordsDoNotMatchError => 'Passwords do not match';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get searchCountryHint => 'Search country';

  @override
  String get confirmPasswordHintText => 'Confirm Password';

  @override
  String get emailAlreadyRegisteredError => 'This email is already registered. Please use a different email or try logging in.';

  @override
  String get checkInformationError => 'Please check your information and try again.';

  @override
  String get invalidInputError => 'Invalid input. Please check your details.';

  @override
  String get connectionError => 'Unable to connect to the server. Please check your internet connection.';

  @override
  String get defaultError => 'An error occurred. Please try again.';

  @override
  String get successSnackBarTitle => 'Success';

  @override
  String get errorSnackBarTitle => 'Error';

  @override
  String get dismissSnackBarAction => 'DISMISS';

  @override
  String get registrationSuccessDefaultMessage => 'Registration successful! Please verify your email with the OTP sent.';

  @override
  String get registrationFailedDefaultMessage => 'Registration failed. Please try again.';

  @override
  String get unexpectedAuthError => 'An unexpected error occurred. Please try again later.';

  @override
  String get loginFailedDefaultMessage => 'Login failed. Please try again.';

  @override
  String get resendOtpSuccessDefaultMessage => 'Verification code has been resent successfully.';

  @override
  String get resendOtpFailedDefaultMessage => 'Failed to resend verification code. Please try again.';

  @override
  String get enterEmailError => 'Please enter your email address';

  @override
  String get alreadyRegisteredPrompt => 'Already have an account?';

  @override
  String get loginLink => 'Login';

  @override
  String get noEmailFoundError => 'No email found. Please log in again.';

  @override
  String get invalidEmailVerificationError => 'Invalid email. Please log in again.';

  @override
  String get errorRetrievingEmailError => 'Error retrieving email. Please log in again.';

  @override
  String get verificationGraphQLErrorDefault => 'An error occurred';

  @override
  String get invalidLoginResponseError => 'Invalid login response';

  @override
  String get verificationFailedDefault => 'Verification failed';

  @override
  String unexpectedVerificationError(Object error) {
    return 'An unexpected error occurred: $error';
  }

  @override
  String get enterOtpError => 'Please enter the OTP';

  @override
  String get otpLengthError => 'OTP must be 6 digits';

  @override
  String get otpNumbersOnlyError => 'OTP must contain only numbers';

  @override
  String get verifyOtpTitle => 'Verify OTP';

  @override
  String enterOtpMessage(Object maskedEmail) {
    return 'Enter the verification code sent to\n$maskedEmail';
  }

  @override
  String get otpHintText => 'Enter 6-digit OTP';

  @override
  String get verifyCodeButton => 'Verify Code';

  @override
  String get didNotReceiveCodePrompt => 'Didn\'t receive the code? ';

  @override
  String get resendLink => 'Resend';
}
