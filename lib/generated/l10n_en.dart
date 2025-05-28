import 'package:intl/intl.dart' as intl;

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
  String get passwordDigitError => 'Password must contain at least one number';

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

  @override
  String get futureBuilderErrorPrefix => 'Error: ';

  @override
  String get unexpectedPasswordResetVerificationError => 'An unexpected error occurred';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get enterEmailToResetPasswordSubtitle => 'Enter your email to reset password';

  @override
  String get passwordResetOtpSentMessage => 'OTP to reset password has been sent to your email.';

  @override
  String get rememberPasswordPrompt => 'Remember your password?';

  @override
  String get signInLink => 'Sign In';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordSubtitle => 'Enter your new password';

  @override
  String get newPasswordHint => 'New Password';

  @override
  String get confirmPasswordHint => 'Confirm Password';

  @override
  String get resetPasswordButton => 'Reset Password';

  @override
  String get passwordRequired => 'Please enter a password';

  @override
  String get passwordLengthError => 'Password must be at least 8 characters long';

  @override
  String get passwordUppercaseError => 'Password must contain at least one uppercase letter';

  @override
  String get passwordLowercaseError => 'Password must contain at least one lowercase letter';

  @override
  String get passwordNumberError => 'Password must contain at least one number';

  @override
  String get passwordSpecialCharError => 'Password must contain at least one special character';

  @override
  String get passwordMismatchError => 'Passwords do not match';

  @override
  String get passwordResetSuccess => 'Your password has been reset successfully';

  @override
  String get genericError => 'An error occurred';

  @override
  String get termsAndConditionsText => 'By using this app, you agree to our Terms and Conditions';

  @override
  String get termsPageTitle => 'Terms and Conditions';

  @override
  String get errorLoadingTerms => 'Error loading terms and conditions. Please try again.';

  @override
  String get errorLoadingPage => 'Error loading page. Please try again.';

  @override
  String get selectLanguageTitle => 'Select Language';

  @override
  String get bottomNavHome => 'Home';

  @override
  String get bottomNavProfile => 'Profile';

  @override
  String get bottomNavLanguage => 'Language';

  @override
  String get homePageTitle => 'Home';

  @override
  String get welcomeBackSubtitle => 'Manage your fire safety equipment efficiently';

  @override
  String get quickActionsTitle => 'Quick Actions';

  @override
  String get actionCardInventory => 'Inventory';

  @override
  String get actionCardServices => 'Services';

  @override
  String get actionCardSettings => 'Settings';

  @override
  String get actionCardNotifications => 'Notifications';

  @override
  String get actionCardNavigation => 'Navigation';

  @override
  String get statusTitle => 'Status';

  @override
  String get notificationsTooltip => 'Notifications';

  @override
  String get confirmLogoutTitle => 'Confirm Logout';

  @override
  String get confirmLogoutMessage => 'Are you sure you want to sign out?';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get logoutButton => 'Logout';

  @override
  String get drawerMenuTitle => 'MENU';

  @override
  String get drawerFeaturesTitle => 'FEATURES';

  @override
  String get drawerOtherTitle => 'OTHER';

  @override
  String get drawerItemDashboard => 'Dashboard';

  @override
  String get drawerItemHome => 'Home';

  @override
  String get drawerItemUsers => 'Users';

  @override
  String get drawerItemService => 'Service';

  @override
  String get drawerItemInventory => 'Inventory';

  @override
  String get drawerItemNavigation => 'Navigation';

  @override
  String get drawerItemProfile => 'Profile';

  @override
  String get drawerItemSettings => 'Settings';

  @override
  String get drawerItemNotifications => 'Notifications';

  @override
  String get serviceRequestsTitle => 'Service Requests';

  @override
  String get refreshTooltip => 'Refresh';

  @override
  String get createServiceRequestTooltip => 'Create Service Request';

  @override
  String get searchServiceRequestsHint => 'Search service requests...';

  @override
  String get errorLoadingServiceRequests => 'Error loading service requests';

  @override
  String get noServiceRequestsFound => 'No Service Requests Found';

  @override
  String get adjustSearchOrFilters => 'Try adjusting your search or filters';

  @override
  String get columnTitle => 'TITLE';

  @override
  String get columnStatus => 'STATUS';

  @override
  String get columnTechnician => 'TECHNICIAN';

  @override
  String get columnDate => 'DATE';

  @override
  String get columnActions => 'ACTIONS';

  @override
  String get noTechnicianAssigned => 'No technician assigned';

  @override
  String get viewDetailsTooltip => 'View Details';

  @override
  String get serviceRequestDetailsTitle => 'Service Request Details';

  @override
  String get requestInformationTitle => 'Request Information';

  @override
  String get titleLabel => 'Title';

  @override
  String get statusLabel => 'Status';

  @override
  String get dateLabel => 'Date';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get clientInformationTitle => 'Client Information';

  @override
  String get technicianInformationTitle => 'Technician Information';

  @override
  String get notAvailable => 'N/A';

  @override
  String get closeButton => 'Close';

  @override
  String get rowsLabel => 'Rows: ';

  @override
  String get rowsPerPageLabel => 'Rows per page: ';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get inventoryTitle => 'Inventory';

  @override
  String get productCreatedSuccess => 'Product created successfully';

  @override
  String errorCreatingProduct(Object error) {
    return 'Error creating product: $error';
  }

  @override
  String get deleteProductTitle => 'Delete Product';

  @override
  String deleteProductConfirmation(Object productName) {
    return 'Are you sure you want to delete $productName?';
  }

  @override
  String get deleteButton => 'Delete';

  @override
  String get productDeletedSuccess => 'Product deleted successfully';

  @override
  String errorDeletingProduct(Object error) {
    return 'Error deleting product: $error';
  }

  @override
  String get productUpdatedSuccess => 'Product updated successfully';

  @override
  String errorUpdatingProduct(Object error) {
    return 'Error updating product: $error';
  }

  @override
  String failedToRefresh(Object error) {
    return 'Failed to refresh: $error';
  }

  @override
  String get newButton => 'New';

  @override
  String get searchExtinguishersHint => 'Search extinguishers...';

  @override
  String get availableExtinguishersTitle => 'Available Extinguishers';

  @override
  String itemCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '$count item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String get noExtinguishersAvailable => 'No extinguishers available';

  @override
  String get noExtinguishersMatchSearch => 'No extinguishers match your search';

  @override
  String get addExtinguisherButton => 'Add Extinguisher';

  @override
  String get unknownType => 'Unknown Type';

  @override
  String stockLabel(Object quantity) {
    return 'Stock: $quantity';
  }

  @override
  String get editTooltip => 'Edit';

  @override
  String get deleteTooltip => 'Delete';

  @override
  String get errorLoadingProducts => 'Error loading products';

  @override
  String paginationPage(Object currentPage, Object totalPages) {
    return 'Page $currentPage of $totalPages';
  }

  @override
  String get columnEmail => 'Email';

  @override
  String get columnPhone => 'Phone';

  @override
  String get columnRole => 'Role';

  @override
  String get locationLabel => 'Location';

  @override
  String get statusVerified => 'Verified';

  @override
  String get statusUnverified => 'Unverified';

  @override
  String get userManagementTitle => 'User Management';

  @override
  String get userListRefreshed => 'User list refreshed successfully';

  @override
  String get addUserTooltip => 'Add User';

  @override
  String get searchUsersHint => 'Search users...';

  @override
  String get errorLoadingUsers => 'Error loading users';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get noUsersMatchSearch => 'No users match your search';

  @override
  String get loadingMessage => 'Loading users...';

  @override
  String showingRecords(Object startIndex, Object endIndex, Object totalCount, Object totalItems) {
    return 'Showing $startIndex-$endIndex of $totalCount';
  }

  @override
  String get requestForServiceTitle => 'Request for Service';

  @override
  String get refillService => 'Refill';

  @override
  String get maintenanceService => 'Maintenance';

  @override
  String get supplyService => 'Supply';

  @override
  String get otherServices => 'Other Services';

  @override
  String get selectServiceLabel => 'Select Service';

  @override
  String get selectTechnicianLabel => 'Select Technician';

  @override
  String get pleaseSelectService => 'Please select a service';

  @override
  String get pleaseSelectTechnician => 'Please select a technician';

  @override
  String get pleaseEnterDescription => 'Please enter a description';

  @override
  String get descriptionTooLong => 'Description too long (max 500 characters)';

  @override
  String get describeServiceRequestHint => 'Describe your service request...';

  @override
  String get unknownErrorOccurred => 'Unknown error occurred';

  @override
  String get networkErrorOccurred => 'Network error occurred. Please check your connection.';

  @override
  String get errorLoadingTechnicians => 'An error occurred while loading technicians';

  @override
  String get noAvailableTechniciansFound => 'No available technicians found';

  @override
  String failedToCreateRequest(Object errorMessage) {
    return 'Failed to create request: $errorMessage';
  }

  @override
  String get submitButton => 'Submit';

  @override
  String get userNotAuthenticated => 'User not authenticated';

  @override
  String get translateServiceLabel => 'Translate Service';

  @override
  String get labelTextKey => 'Service';

  @override
  String get loadingProfileMessage => 'Loading profile...';

  @override
  String get errorLoadingProfile => 'Error Loading Profile';

  @override
  String get profileDataNotFound => 'Profile data not found';

  @override
  String get profilePageTitle => 'Profile';

  @override
  String failedToUpdateProfileImage(Object error) {
    return 'Failed to update profile image: $error';
  }

  @override
  String failedToRemoveProfileImage(Object error) {
    return 'Failed to remove profile image: $error';
  }

  @override
  String get anonymousUserName => '____   _____';

  @override
  String get verifiedAccountLabel => 'Verified Account';

  @override
  String get personalInformationTitle => 'Personal Information';

  @override
  String get addressTitle => 'Address';

  @override
  String get emailLabel => 'Email';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get roleLabel => 'Role';

  @override
  String get dateOfBirthLabel => 'Date of Birth';

  @override
  String get streetLabel => 'Street';

  @override
  String get cityStateLabel => 'City/State';

  @override
  String get zipCodeLabel => 'ZIP Code';

  @override
  String get notProvided => 'Not provided';

  @override
  String get retryButton => 'Retry';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get profileSettingsSectionTitle => 'Profile';

  @override
  String get appSettingsSectionTitle => 'App Settings';

  @override
  String get profileSettingsTitle => 'Profile Settings';

  @override
  String get profileSettingsSubtitle => 'Update your personal information';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get changePasswordSubtitle => 'Manage your security settings';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSubtitle => 'Change app language';

  @override
  String get notifications_loadingUser => 'Notifications (Loading User...)';

  @override
  String get notifications_error => 'Notifications (Error)';

  @override
  String get notifications_title => 'Notifications';

  @override
  String get tooltip_showAll => 'Show All';

  @override
  String get tooltip_showUnread => 'Show Unread Only';

  @override
  String get menu_markAllAsRead => 'Mark All as Read';

  @override
  String get menu_refresh => 'Refresh';

  @override
  String get loading_userData => 'Loading user data...';

  @override
  String get loading_notifications => 'Loading notifications...';

  @override
  String get emptyState_unreadTitle => 'No unread notifications';

  @override
  String get emptyState_allTitle => 'No notifications yet';

  @override
  String get emptyState_unreadSubtitle => 'All caught up! 🎉';

  @override
  String get emptyState_allSubtitle => 'Notifications will appear here when you receive them';

  @override
  String get errorState_title => 'Failed to load notifications';

  @override
  String get errorState_retry => 'Try Again';

  @override
  String get delete_swipeAction => 'Delete';

  @override
  String get highPriority_label => 'High Priority';

  @override
  String get date_justNow => 'Just now';

  @override
  String date_minutesAgo(Object minutes) {
    return '${minutes}m ago';
  }

  @override
  String date_hoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String date_daysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get deleteConfirmation_title => 'Delete Notification';

  @override
  String deleteConfirmation_content(Object title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String get button_cancel => 'Cancel';

  @override
  String get button_delete => 'Delete';

  @override
  String get button_undo => 'Undo';

  @override
  String snackbar_notificationDeleted(Object title) {
    return 'Deleted \"$title\"';
  }

  @override
  String get snackbar_markedAllAsRead => 'All notifications marked as read';

  @override
  String get addTechnician_dialogTitle => 'Add New Technician';

  @override
  String get textField_firstName => 'First Name';

  @override
  String get textField_lastName => 'Last Name';

  @override
  String get textField_email => 'Email';

  @override
  String get textField_phone => 'Phone';

  @override
  String get validation_firstNameRequired => 'Please enter a first name';

  @override
  String get validation_lastNameRequired => 'Please enter a last name';

  @override
  String get validation_emailRequired => 'Please enter an email';

  @override
  String get validation_emailValid => 'Please enter a valid email';

  @override
  String get validation_phoneRequired => 'Please enter a phone number';

  @override
  String get button_create => 'Create';

  @override
  String get button_creating => 'Creating...';

  @override
  String get error_requestTimedOut => 'Request timed out';

  @override
  String get error_prefix => 'Error';

  @override
  String get snackbar_technicianCreatedSuccess => 'Technician created successfully';

  @override
  String get snackbar_technicianCreatedError => 'Failed to create technician';
}
