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

  /// Main title on the register header
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// Subtitle prompting the user to sign up on the register header
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started'**
  String get signUpToGetStartedSubtitle;

  /// Validation error when phone number is empty on the register form
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get enterPhoneNumberError;

  /// Validation error for incorrect Rwanda phone number length
  ///
  /// In en, this message translates to:
  /// **'Rwanda phone numbers must be 9 digits'**
  String get rwandaPhoneNumberLengthError;

  /// Validation error for incorrect Rwanda phone number starting digit
  ///
  /// In en, this message translates to:
  /// **'Rwanda phone numbers must start with 7'**
  String get rwandaPhoneNumberStartError;

  /// Validation error for phone number less than minimum required length
  ///
  /// In en, this message translates to:
  /// **'Phone number must be at least 9 digits'**
  String get phoneNumberMinLengthError;

  /// Validation error for phone number exceeding maximum allowed length
  ///
  /// In en, this message translates to:
  /// **'Phone number cannot exceed 10 digits'**
  String get phoneNumberMaxLengthError;

  /// Validation error when password is empty on the register form
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get enterPasswordError;

  /// Validation error for password less than minimum required length
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get passwordMinLengthError;

  /// Validation error for password missing a digit
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get passwordDigitError;

  /// Validation error when confirm password is empty on the register form
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordError;

  /// Validation error when confirm password does not match password
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatchError;

  /// Label text for the phone number input section on the register form
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// Hint text for the country search input in the country code picker
  ///
  /// In en, this message translates to:
  /// **'Search country'**
  String get searchCountryHint;

  /// Hint text for the confirm password input field on the register form
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordHintText;

  /// GraphQL error message for a registered email (status 409)
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. Please use a different email or try logging in.'**
  String get emailAlreadyRegisteredError;

  /// GraphQL error message for bad request (status 400)
  ///
  /// In en, this message translates to:
  /// **'Please check your information and try again.'**
  String get checkInformationError;

  /// GraphQL error message for unprocessable entity (status 422)
  ///
  /// In en, this message translates to:
  /// **'Invalid input. Please check your details.'**
  String get invalidInputError;

  /// Error message for network connection issues
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the server. Please check your internet connection.'**
  String get connectionError;

  /// Default generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get defaultError;

  /// Title for success snackbars
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get successSnackBarTitle;

  /// Title for error snackbars
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorSnackBarTitle;

  /// Label for the dismiss action in snackbars
  ///
  /// In en, this message translates to:
  /// **'DISMISS'**
  String get dismissSnackBarAction;

  /// Default success message after registration
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Please verify your email with the OTP sent.'**
  String get registrationSuccessDefaultMessage;

  /// Default failure message after registration
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registrationFailedDefaultMessage;

  /// Generic error message for unexpected authentication issues
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again later.'**
  String get unexpectedAuthError;

  /// Default failure message after login
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginFailedDefaultMessage;

  /// Default success message after resending OTP
  ///
  /// In en, this message translates to:
  /// **'Verification code has been resent successfully.'**
  String get resendOtpSuccessDefaultMessage;

  /// Default failure message after failing to resend OTP
  ///
  /// In en, this message translates to:
  /// **'Failed to resend verification code. Please try again.'**
  String get resendOtpFailedDefaultMessage;

  /// Validation error when email address is empty on the forgot password form
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get enterEmailError;

  /// Prompt for users who already have an account on the forgot password page
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyRegisteredPrompt;

  /// Text for the login link on the forgot password page
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginLink;

  /// Error message when email is not found in SharedPreferences during verification
  ///
  /// In en, this message translates to:
  /// **'No email found. Please log in again.'**
  String get noEmailFoundError;

  /// Error message when the retrieved email is invalid during verification
  ///
  /// In en, this message translates to:
  /// **'Invalid email. Please log in again.'**
  String get invalidEmailVerificationError;

  /// Error message when there's an error retrieving email from SharedPreferences
  ///
  /// In en, this message translates to:
  /// **'Error retrieving email. Please log in again.'**
  String get errorRetrievingEmailError;

  /// Default error message for GraphQL exceptions during verification
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get verificationGraphQLErrorDefault;

  /// Error message for an invalid response after successful verification
  ///
  /// In en, this message translates to:
  /// **'Invalid login response'**
  String get invalidLoginResponseError;

  /// Default failure message for verification
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verificationFailedDefault;

  /// Generic error message for unexpected issues during verification
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred: {error}'**
  String unexpectedVerificationError(Object error);

  /// Validation error when OTP field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter the OTP'**
  String get enterOtpError;

  /// Validation error for incorrect OTP length
  ///
  /// In en, this message translates to:
  /// **'OTP must be 6 digits'**
  String get otpLengthError;

  /// Validation error when OTP contains non-numeric characters
  ///
  /// In en, this message translates to:
  /// **'OTP must contain only numbers'**
  String get otpNumbersOnlyError;

  /// Title of the Verify OTP page
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtpTitle;

  /// Message prompting the user to enter the OTP, includes masked email
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to\n{maskedEmail}'**
  String enterOtpMessage(Object maskedEmail);

  /// Hint text for the OTP input field
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit OTP'**
  String get otpHintText;

  /// Text for the Verify Code button
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCodeButton;

  /// Prompt asking if the user didn't receive the OTP
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get didNotReceiveCodePrompt;

  /// Text for the Resend OTP link
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resendLink;

  /// Prefix for error messages shown in FutureBuilder
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get futureBuilderErrorPrefix;

  /// Generic error message for unexpected issues during password reset verification
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedPasswordResetVerificationError;

  /// Main title on the Forgot Password header
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// Subtitle prompting the user to enter email to reset password
  ///
  /// In en, this message translates to:
  /// **'Enter your email to reset password'**
  String get enterEmailToResetPasswordSubtitle;

  /// Success message after sending password reset OTP
  ///
  /// In en, this message translates to:
  /// **'OTP to reset password has been sent to your email.'**
  String get passwordResetOtpSentMessage;

  /// Prompt for users who remember their password on the forget password page
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get rememberPasswordPrompt;

  /// Text for the Sign In link on the forget password page
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInLink;

  /// Title for the reset password page
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// Subtitle instruction on reset password page
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get resetPasswordSubtitle;

  /// Hint text for new password field
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordHint;

  /// Hint text for confirm password field
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordHint;

  /// Text for reset password button
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordButton;

  /// Error when password field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get passwordRequired;

  /// Error when password is too short
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get passwordLengthError;

  /// Error when password lacks uppercase letter
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get passwordUppercaseError;

  /// Error when password lacks lowercase letter
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get passwordLowercaseError;

  /// Error when password lacks number
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get passwordNumberError;

  /// Error when password lacks special character
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one special character'**
  String get passwordSpecialCharError;

  /// Error when passwords don't match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatchError;

  /// Success message after password reset
  ///
  /// In en, this message translates to:
  /// **'Your password has been reset successfully'**
  String get passwordResetSuccess;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get genericError;

  /// Text for terms and conditions agreement
  ///
  /// In en, this message translates to:
  /// **'By using this app, you agree to our Terms and Conditions'**
  String get termsAndConditionsText;

  /// Title for the Terms and Conditions page
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsPageTitle;

  /// Error message when loading terms and conditions fails
  ///
  /// In en, this message translates to:
  /// **'Error loading terms and conditions. Please try again.'**
  String get errorLoadingTerms;

  /// Error message when loading a page fails
  ///
  /// In en, this message translates to:
  /// **'Error loading page. Please try again.'**
  String get errorLoadingPage;

  /// Title for the language selection page
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguageTitle;

  /// Label for the Home tab in the bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get bottomNavHome;

  /// Label for the Profile tab in the bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get bottomNavProfile;

  /// Label for the Language tab in the bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get bottomNavLanguage;

  /// Title for the Home page
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homePageTitle;

  /// Subtitle for the welcome back message
  ///
  /// In en, this message translates to:
  /// **'Manage your fire safety equipment efficiently'**
  String get welcomeBackSubtitle;

  /// Title for the quick actions section
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActionsTitle;

  /// Label for the inventory action card
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get actionCardInventory;

  /// Label for the services action card
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get actionCardServices;

  /// Label for the settings action card
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get actionCardSettings;

  /// Label for the notifications action card
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get actionCardNotifications;

  /// Label for the navigation action card
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get actionCardNavigation;

  /// Title for the status section
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusTitle;

  /// Tooltip text for the notifications icon
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTooltip;

  /// Title for the logout confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogoutTitle;

  /// Message for the logout confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get confirmLogoutMessage;

  /// Text for the cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// Text for the logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButton;

  /// Title for the main menu section in the drawer
  ///
  /// In en, this message translates to:
  /// **'MENU'**
  String get drawerMenuTitle;

  /// Title for the features section in the drawer
  ///
  /// In en, this message translates to:
  /// **'FEATURES'**
  String get drawerFeaturesTitle;

  /// Title for the other section in the drawer
  ///
  /// In en, this message translates to:
  /// **'OTHER'**
  String get drawerOtherTitle;

  /// Label for the Dashboard menu item in the drawer
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get drawerItemDashboard;

  /// Label for the Home menu item in the drawer (if used)
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get drawerItemHome;

  /// Label for the Users menu item in the drawer
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get drawerItemUsers;

  /// Label for the Service menu item in the drawer
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get drawerItemService;

  /// Label for the Inventory menu item in the drawer
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get drawerItemInventory;

  /// Label for the Navigation menu item in the drawer
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get drawerItemNavigation;

  /// Label for the Profile menu item in the drawer
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get drawerItemProfile;

  /// Label for the Settings menu item in the drawer
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerItemSettings;

  /// Label for the Notifications menu item in the drawer
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get drawerItemNotifications;

  /// Title for the service requests screen
  ///
  /// In en, this message translates to:
  /// **'Service Requests'**
  String get serviceRequestsTitle;

  /// Tooltip for the refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshTooltip;

  /// Tooltip for the create service request button
  ///
  /// In en, this message translates to:
  /// **'Create Service Request'**
  String get createServiceRequestTooltip;

  /// Hint text for the service requests search bar
  ///
  /// In en, this message translates to:
  /// **'Search service requests...'**
  String get searchServiceRequestsHint;

  /// Error message when service requests fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading service requests'**
  String get errorLoadingServiceRequests;

  /// Message displayed when no service requests are found
  ///
  /// In en, this message translates to:
  /// **'No Service Requests Found'**
  String get noServiceRequestsFound;

  /// Hint text when no service requests are found
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get adjustSearchOrFilters;

  /// Header for the 'Title' column in the data table
  ///
  /// In en, this message translates to:
  /// **'TITLE'**
  String get columnTitle;

  /// Header for the 'Status' column in the data table
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get columnStatus;

  /// Header for the 'Technician' column in the data table
  ///
  /// In en, this message translates to:
  /// **'TECHNICIAN'**
  String get columnTechnician;

  /// Header for the 'Date' column in the data table
  ///
  /// In en, this message translates to:
  /// **'DATE'**
  String get columnDate;

  /// Header for the 'Actions' column in the data table
  ///
  /// In en, this message translates to:
  /// **'ACTIONS'**
  String get columnActions;

  /// Text displayed when no technician is assigned to a service request
  ///
  /// In en, this message translates to:
  /// **'No technician assigned'**
  String get noTechnicianAssigned;

  /// Tooltip for the view details button
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetailsTooltip;

  /// Title for the service request details dialog
  ///
  /// In en, this message translates to:
  /// **'Service Request Details'**
  String get serviceRequestDetailsTitle;

  /// Title for the request information section in the details dialog
  ///
  /// In en, this message translates to:
  /// **'Request Information'**
  String get requestInformationTitle;

  /// Label for the 'Title' field in the details dialog
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// Label for the 'Status' field in the details dialog
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// Label for the 'Date' field in the details dialog
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// Label for the 'Description' field in the details dialog
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// Title for the client information section in the details dialog
  ///
  /// In en, this message translates to:
  /// **'Client Information'**
  String get clientInformationTitle;

  /// Title for the technician information section in the details dialog
  ///
  /// In en, this message translates to:
  /// **'Technician Information'**
  String get technicianInformationTitle;

  /// Abbreviation for Not Available
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// Text for the close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// Label for the rows per page dropdown (small screen)
  ///
  /// In en, this message translates to:
  /// **'Rows: '**
  String get rowsLabel;

  /// Label for the rows per page dropdown (regular screen)
  ///
  /// In en, this message translates to:
  /// **'Rows per page: '**
  String get rowsPerPageLabel;

  /// Status: Pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// Status: In Progress
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// Status: Completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// Status: Cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// Title for the inventory page
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventoryTitle;

  /// Success message after creating a product
  ///
  /// In en, this message translates to:
  /// **'Product created successfully'**
  String get productCreatedSuccess;

  /// No description provided for @errorCreatingProduct.
  ///
  /// In en, this message translates to:
  /// **'Error creating product: {error}'**
  String errorCreatingProduct(Object error);

  /// Title for the delete product dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get deleteProductTitle;

  /// No description provided for @deleteProductConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {productName}?'**
  String deleteProductConfirmation(Object productName);

  /// Text for the delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// Success message after deleting a product
  ///
  /// In en, this message translates to:
  /// **'Product deleted successfully'**
  String get productDeletedSuccess;

  /// No description provided for @errorDeletingProduct.
  ///
  /// In en, this message translates to:
  /// **'Error deleting product: {error}'**
  String errorDeletingProduct(Object error);

  /// Success message after updating a product
  ///
  /// In en, this message translates to:
  /// **'Product updated successfully'**
  String get productUpdatedSuccess;

  /// No description provided for @errorUpdatingProduct.
  ///
  /// In en, this message translates to:
  /// **'Error updating product: {error}'**
  String errorUpdatingProduct(Object error);

  /// No description provided for @failedToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Failed to refresh: {error}'**
  String failedToRefresh(Object error);

  /// Text for the new button
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newButton;

  /// Hint text for the extinguishers search bar
  ///
  /// In en, this message translates to:
  /// **'Search extinguishers...'**
  String get searchExtinguishersHint;

  /// Title for the available extinguishers section
  ///
  /// In en, this message translates to:
  /// **'Available Extinguishers'**
  String get availableExtinguishersTitle;

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} one{{count} item} other{{count} items}}'**
  String itemCount(num count);

  /// Message displayed when no extinguishers are available
  ///
  /// In en, this message translates to:
  /// **'No extinguishers available'**
  String get noExtinguishersAvailable;

  /// Message displayed when no extinguishers match the search criteria
  ///
  /// In en, this message translates to:
  /// **'No extinguishers match your search'**
  String get noExtinguishersMatchSearch;

  /// Text for the add extinguisher button
  ///
  /// In en, this message translates to:
  /// **'Add Extinguisher'**
  String get addExtinguisherButton;

  /// Label for unknown extinguisher type
  ///
  /// In en, this message translates to:
  /// **'Unknown Type'**
  String get unknownType;

  /// No description provided for @stockLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock: {quantity}'**
  String stockLabel(Object quantity);

  /// Tooltip for the edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editTooltip;

  /// Tooltip for the delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteTooltip;

  /// Error message when loading products fails
  ///
  /// In en, this message translates to:
  /// **'Error loading products'**
  String get errorLoadingProducts;

  /// No description provided for @paginationPage.
  ///
  /// In en, this message translates to:
  /// **'Page {currentPage} of {totalPages}'**
  String paginationPage(Object currentPage, Object totalPages);

  /// Header for the Email column in the user table
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get columnEmail;

  /// Header for the Phone column in the user table
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get columnPhone;

  /// Header for the Role column in the user table
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get columnRole;

  /// Label for Location in user details
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// Status text for a verified user
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get statusVerified;

  /// Status text for an unverified user
  ///
  /// In en, this message translates to:
  /// **'Unverified'**
  String get statusUnverified;

  /// Title for the user management page
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagementTitle;

  /// Success message after refreshing the user list
  ///
  /// In en, this message translates to:
  /// **'User list refreshed successfully'**
  String get userListRefreshed;

  /// Tooltip for the add user button
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get addUserTooltip;

  /// Hint text for the users search bar
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get searchUsersHint;

  /// Error message when loading users fails
  ///
  /// In en, this message translates to:
  /// **'Error loading users'**
  String get errorLoadingUsers;

  /// Message displayed when no users are found
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// Message displayed when no users match the search criteria
  ///
  /// In en, this message translates to:
  /// **'No users match your search'**
  String get noUsersMatchSearch;

  /// Message displayed while users are loading
  ///
  /// In en, this message translates to:
  /// **'Loading users...'**
  String get loadingMessage;

  /// Text showing the range of records being displayed
  ///
  /// In en, this message translates to:
  /// **'Showing {startIndex}-{endIndex} of {totalCount}'**
  String showingRecords(Object startIndex, Object endIndex, Object totalCount, Object totalItems);

  /// Title of the service request modal
  ///
  /// In en, this message translates to:
  /// **'Request for Service'**
  String get requestForServiceTitle;

  /// Service option: Refill
  ///
  /// In en, this message translates to:
  /// **'Refill'**
  String get refillService;

  /// Service option: Maintenance
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenanceService;

  /// Service option: Supply
  ///
  /// In en, this message translates to:
  /// **'Supply'**
  String get supplyService;

  /// Service option: Other Services
  ///
  /// In en, this message translates to:
  /// **'Other Services'**
  String get otherServices;

  /// Label for the service selection dropdown
  ///
  /// In en, this message translates to:
  /// **'Select Service'**
  String get selectServiceLabel;

  /// Label for the technician selection dropdown
  ///
  /// In en, this message translates to:
  /// **'Select Technician'**
  String get selectTechnicianLabel;

  /// Validation message: Service selection required
  ///
  /// In en, this message translates to:
  /// **'Please select a service'**
  String get pleaseSelectService;

  /// Validation message: Technician selection required
  ///
  /// In en, this message translates to:
  /// **'Please select a technician'**
  String get pleaseSelectTechnician;

  /// Validation message: Description required
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get pleaseEnterDescription;

  /// Validation message: Description exceeds character limit
  ///
  /// In en, this message translates to:
  /// **'Description too long (max 500 characters)'**
  String get descriptionTooLong;

  /// Hint text for the service request description field
  ///
  /// In en, this message translates to:
  /// **'Describe your service request...'**
  String get describeServiceRequestHint;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred'**
  String get unknownErrorOccurred;

  /// Network connection error message
  ///
  /// In en, this message translates to:
  /// **'Network error occurred. Please check your connection.'**
  String get networkErrorOccurred;

  /// Error message when technicians fail to load
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading technicians'**
  String get errorLoadingTechnicians;

  /// Message when no technicians are available
  ///
  /// In en, this message translates to:
  /// **'No available technicians found'**
  String get noAvailableTechniciansFound;

  /// Error message when service request creation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create request: {errorMessage}'**
  String failedToCreateRequest(Object errorMessage);

  /// Text for the submit button
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitButton;

  /// Error message when the user is not authenticated
  ///
  /// In en, this message translates to:
  /// **'User not authenticated'**
  String get userNotAuthenticated;

  /// Label for the translate service option
  ///
  /// In en, this message translates to:
  /// **'Translate Service'**
  String get translateServiceLabel;

  /// The label text for the service
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get labelTextKey;

  /// Message displayed while the profile is loading
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get loadingProfileMessage;

  /// Title for the error screen when profile loading fails
  ///
  /// In en, this message translates to:
  /// **'Error Loading Profile'**
  String get errorLoadingProfile;

  /// Error message when profile data is not found
  ///
  /// In en, this message translates to:
  /// **'Profile data not found'**
  String get profileDataNotFound;

  /// Title for the Profile page
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profilePageTitle;

  /// Error message when updating profile image fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile image: {error}'**
  String failedToUpdateProfileImage(Object error);

  /// Error message when removing profile image fails
  ///
  /// In en, this message translates to:
  /// **'Failed to remove profile image: {error}'**
  String failedToRemoveProfileImage(Object error);

  /// Placeholder text for user name when not available
  ///
  /// In en, this message translates to:
  /// **'____   _____'**
  String get anonymousUserName;

  /// Label indicating a user has a verified account
  ///
  /// In en, this message translates to:
  /// **'Verified Account'**
  String get verifiedAccountLabel;

  /// Title for the Personal Information section
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformationTitle;

  /// Title for the Address section
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressTitle;

  /// Label for the Email field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// Label for the Phone field
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// Label for the Role field
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get roleLabel;

  /// Label for the Date of Birth field
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirthLabel;

  /// Label for the Street field in address
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get streetLabel;

  /// Label for the City/State field in address
  ///
  /// In en, this message translates to:
  /// **'City/State'**
  String get cityStateLabel;

  /// Label for the ZIP Code field in address
  ///
  /// In en, this message translates to:
  /// **'ZIP Code'**
  String get zipCodeLabel;

  /// Placeholder text for information that is not provided
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// Text for the retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// Title for the Settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Section title for profile-related settings
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileSettingsSectionTitle;

  /// Section title for app-related settings
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettingsSectionTitle;

  /// Title for the profile settings tile
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettingsTitle;

  /// Subtitle for the profile settings tile
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get profileSettingsSubtitle;

  /// Title for the change password settings tile
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// Subtitle for the change password settings tile
  ///
  /// In en, this message translates to:
  /// **'Manage your security settings'**
  String get changePasswordSubtitle;

  /// Title for the language settings tile
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// Subtitle for the language settings tile
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get languageSubtitle;

  /// Title for the notifications page while loading user data
  ///
  /// In en, this message translates to:
  /// **'Notifications (Loading User...)'**
  String get notifications_loadingUser;

  /// Title for the notifications page when there is an error
  ///
  /// In en, this message translates to:
  /// **'Notifications (Error)'**
  String get notifications_error;

  /// Title for the notifications page
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications_title;

  /// Tooltip for showing all notifications
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get tooltip_showAll;

  /// Tooltip for showing only unread notifications
  ///
  /// In en, this message translates to:
  /// **'Show Unread Only'**
  String get tooltip_showUnread;

  /// Menu option to mark all notifications as read
  ///
  /// In en, this message translates to:
  /// **'Mark All as Read'**
  String get menu_markAllAsRead;

  /// Menu option to refresh notifications
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get menu_refresh;

  /// Message displayed while user data is loading
  ///
  /// In en, this message translates to:
  /// **'Loading user data...'**
  String get loading_userData;

  /// Message displayed while notifications are loading
  ///
  /// In en, this message translates to:
  /// **'Loading notifications...'**
  String get loading_notifications;

  /// Title for the empty state when there are no unread notifications
  ///
  /// In en, this message translates to:
  /// **'No unread notifications'**
  String get emptyState_unreadTitle;

  /// Title for the empty state when there are no notifications
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get emptyState_allTitle;

  /// Subtitle for the empty state when there are no unread notifications
  ///
  /// In en, this message translates to:
  /// **'All caught up! 🎉'**
  String get emptyState_unreadSubtitle;

  /// Subtitle for the empty state when there are no notifications
  ///
  /// In en, this message translates to:
  /// **'Notifications will appear here when you receive them'**
  String get emptyState_allSubtitle;

  /// Title for the error state when notifications fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get errorState_title;

  /// Text for the retry button in the error state
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get errorState_retry;

  /// Text for the delete action when swiping a notification
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete_swipeAction;

  /// Label for high priority notifications
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get highPriority_label;

  /// Time difference less than a minute
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get date_justNow;

  /// Time difference in minutes
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String date_minutesAgo(Object minutes);

  /// Time difference in hours (less than a day)
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String date_hoursAgo(int hours);

  /// Time difference in days (less than a week)
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String date_daysAgo(int days);

  /// Title for the delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Notification'**
  String get deleteConfirmation_title;

  /// Confirmation message for deleting a notification
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String deleteConfirmation_content(Object title);

  /// Text for the cancel button in the delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get button_cancel;

  /// Text for the delete button in the delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get button_delete;

  /// Text for the undo button in the snackbar after deleting a notification
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get button_undo;

  /// Snackbar message after deleting a notification
  ///
  /// In en, this message translates to:
  /// **'Deleted \"{title}\"'**
  String snackbar_notificationDeleted(Object title);

  /// Snackbar message after marking all notifications as read
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read'**
  String get snackbar_markedAllAsRead;

  /// Title of the dialog to add a new technician
  ///
  /// In en, this message translates to:
  /// **'Add New Technician'**
  String get addTechnician_dialogTitle;

  /// Label for the first name input field
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get textField_firstName;

  /// Label for the last name input field
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get textField_lastName;

  /// Label for the email input field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get textField_email;

  /// Label for the phone input field
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get textField_phone;

  /// Validation message for required first name
  ///
  /// In en, this message translates to:
  /// **'Please enter a first name'**
  String get validation_firstNameRequired;

  /// Validation message for required last name
  ///
  /// In en, this message translates to:
  /// **'Please enter a last name'**
  String get validation_lastNameRequired;

  /// Validation message for required email
  ///
  /// In en, this message translates to:
  /// **'Please enter an email'**
  String get validation_emailRequired;

  /// Validation message for invalid email format
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validation_emailValid;

  /// Validation message for required phone number
  ///
  /// In en, this message translates to:
  /// **'Please enter a phone number'**
  String get validation_phoneRequired;

  /// Text for the create button
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get button_create;

  /// Text for the create button while the request is in progress
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get button_creating;

  /// Error message when a request times out
  ///
  /// In en, this message translates to:
  /// **'Request timed out'**
  String get error_requestTimedOut;

  /// Prefix used for general error messages
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error_prefix;

  /// Snackbar message on successful technician creation
  ///
  /// In en, this message translates to:
  /// **'Technician created successfully'**
  String get snackbar_technicianCreatedSuccess;

  /// Snackbar message on failed technician creation (generic)
  ///
  /// In en, this message translates to:
  /// **'Failed to create technician'**
  String get snackbar_technicianCreatedError;
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
