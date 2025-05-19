import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Kinyarwanda (`rw`).
class SRw extends S {
  SRw([String locale = 'rw']) : super(locale);

  @override
  String get onboardingTitle1 => 'Murakaza neza kuri FireSecure360';

  @override
  String get onboardingDesc1 => 'Rinda ibyaawe, Kanda Hano';

  @override
  String get onboardingTitle2 => 'Tangira';

  @override
  String get onboardingDesc2 => 'Fungura konti cyangwa winjire kugira ngo ubone ibintu byose';

  @override
  String get onboardingTitle3 => 'Umutekano n\'Uburyo Bworoshye';

  @override
  String get onboardingDesc3 => 'Gufasha imicungire y\'umutekano wawe';

  @override
  String get register => 'Iyandikishe';

  @override
  String get login => 'Injira';

  @override
  String get dontHaveAccountPrompt => 'Ntabwo ufite konti?';

  @override
  String get signUpLink => 'Iyandikishe';

  @override
  String get welcomeBackTitle => 'Murakaza neza ';

  @override
  String get signInToContinueSubtitle => 'Injira kugirango ukomeze';

  @override
  String get fillAllFieldsError => 'Uzuze ibibanza byose';

  @override
  String get invalidEmailError => 'Andika imeyili yemewe';

  @override
  String get loginFailedDefaultError => 'Kwinjira byanze';

  @override
  String get emailVerificationRequiredError => 'Emeza imeyili yawe mbere yo kwinjira';

  @override
  String get loginSuccessfulMessage => 'Kwinjira byagenze neza!';

  @override
  String get emailSaveFailedError => 'Gukoresha imeyili byanze. Ongera ugerageze.';

  @override
  String get unexpectedError => 'Habayeho ikibazo kitari giteganijwe';

  @override
  String get emailHintText => 'Imeyili';

  @override
  String get passwordHintText => 'Ijambo ry\'ibanga';

  @override
  String get forgotPasswordLink => 'Wibagiwe ijambo ry\'ibanga?';

  @override
  String get createAccountTitle => 'Fungura konti';

  @override
  String get signUpToGetStartedSubtitle => 'Iyandikishe kugirango utangire';

  @override
  String get enterPhoneNumberError => 'Andika nimero ya telefone yawe';

  @override
  String get rwandaPhoneNumberLengthError => 'Nimero za telefone z\'u Rwanda zigomba kugira imibare 9';

  @override
  String get rwandaPhoneNumberStartError => 'Nimero za telefone z\'u Rwanda zigomba gutangira na 7';

  @override
  String get phoneNumberMinLengthError => 'Nimero ya telefone igomba kugira byibura imibare 9';

  @override
  String get phoneNumberMaxLengthError => 'Nimero ya telefone ntishobora kurenza imibare 10';

  @override
  String get enterPasswordError => 'Andika ijambo ry\'ibanga';

  @override
  String get passwordMinLengthError => 'Ijambo ry\'ibanga rigomba kugira byibura inyuguti 8';

  @override
  String get passwordDigitError => 'Ijambo ry\'ibanga rigomba kugira byibura umubare umwe';

  @override
  String get confirmPasswordError => 'Emeza ijambo ry\'ibanga';

  @override
  String get passwordsDoNotMatchError => 'Amagambo y\'ibanga ntabwo ahura';

  @override
  String get phoneNumberLabel => 'Nimero ya telefone';

  @override
  String get searchCountryHint => 'Shakisha igihugu';

  @override
  String get confirmPasswordHintText => 'Emeza ijambo ry\'ibanga';

  @override
  String get emailAlreadyRegisteredError => 'Iyi imeyili yamaze kwandikwa. Koresha indi imeyili cyangwa ugerageze kwinjira.';

  @override
  String get checkInformationError => 'Reba amakuru yawe maze ungerageze.';

  @override
  String get invalidInputError => 'Ibyinjiye ntibikoze neza. Reba ibyo winjije.';

  @override
  String get connectionError => 'Ntushobora guhuza na seriveri. Reba interineti yawe.';

  @override
  String get defaultError => 'Habayeho ikibazo. Ongera ugerageze.';

  @override
  String get successSnackBarTitle => 'Byagenze neza';

  @override
  String get errorSnackBarTitle => 'Ikibazo';

  @override
  String get dismissSnackBarAction => 'Funga';

  @override
  String get registrationSuccessDefaultMessage => 'Kwiyandikisha byagenze neza! Emeza imeyili yawe ukoresheje OTP yoherejwe.';

  @override
  String get registrationFailedDefaultMessage => 'Kwiyandikisha byaranze. Ongera ugerageze.';

  @override
  String get unexpectedAuthError => 'Habayeho ikibazo kitari giteganijwe. Ongera ugerageze nyuma.';

  @override
  String get loginFailedDefaultMessage => 'Kwinjira byaranze. Ongera ugerageze.';

  @override
  String get resendOtpSuccessDefaultMessage => 'Kode  yoherejwe bundi bushya.';

  @override
  String get resendOtpFailedDefaultMessage => 'Gusubiza kode  byaranze. Ongera ugerageze.';

  @override
  String get enterEmailError => 'Andika imeyili yawe';

  @override
  String get alreadyRegisteredPrompt => 'Usanzwe ufite konti?';

  @override
  String get loginLink => 'Injira';

  @override
  String get noEmailFoundError => 'Nta imeyili yabonetse. Nyamuneka ongera winjire.';

  @override
  String get invalidEmailVerificationError => 'Imeyili ntiyemewe. Nyamuneka ongera winjire.';

  @override
  String get errorRetrievingEmailError => 'Ikibazo mu gushaka imeyili. Nyamuneka ongera winjire.';

  @override
  String get verificationGraphQLErrorDefault => 'Habayeho ikibazo';

  @override
  String get invalidLoginResponseError => 'Igisubizo cyo kwinjira nticikozeneza';

  @override
  String get verificationFailedDefault => 'Gushimangira byaranze';

  @override
  String unexpectedVerificationError(Object error) {
    return 'Habayeho ikibazo kitari giteganijwe: $error';
  }

  @override
  String get enterOtpError => 'Nyamuneka andika OTP';

  @override
  String get otpLengthError => 'OTP igomba kugira imibare 6';

  @override
  String get otpNumbersOnlyError => 'OTP igomba kugira imibare gusa';

  @override
  String get verifyOtpTitle => 'Emeza OTP';

  @override
  String enterOtpMessage(Object maskedEmail) {
    return 'Andika kode  yoherejwe kuri\n$maskedEmail';
  }

  @override
  String get otpHintText => 'Andika OTP y\'imibare 6';

  @override
  String get verifyCodeButton => 'Emeza Kode';

  @override
  String get didNotReceiveCodePrompt => 'Ntabwo wakiriye kode?';

  @override
  String get resendLink => 'Ongera wohereze';

  @override
  String get futureBuilderErrorPrefix => 'Ikibazo mu gushaka amakuru';

  @override
  String get unexpectedPasswordResetVerificationError => 'Habayeho ikibazo kitari giteganijwe mu kwemeza ijambo ry\'ibanga rishya';

  @override
  String get forgotPasswordTitle => 'Wibagiwe ijambo ry\'ibanga';

  @override
  String get enterEmailToResetPasswordSubtitle => 'Andika imeyili yawe kugirango usubizeho ijambo ry\'ibanga';

  @override
  String get passwordResetOtpSentMessage => 'OTP yo gusubiza ijambo ry\'ibanga yoherejwe kuri imeyili yawe.';

  @override
  String get rememberPasswordPrompt => 'Wibuka ijambo ry\'ibanga ryawe?';

  @override
  String get signInLink => 'Injira';

  @override
  String get resetPasswordTitle => 'Ongera ushyireho ijambo ry\'ibanga';

  @override
  String get resetPasswordSubtitle => 'Injiza ijambo ry\'ibanga rishya';

  @override
  String get newPasswordHint => 'Ijambo ry\'ibanga rishya';

  @override
  String get confirmPasswordHint => 'Emeza ijambo ry\'ibanga';

  @override
  String get resetPasswordButton => 'Ohereza';

  @override
  String get passwordRequired => 'Nyamuneka andika ijambo ry\'ibanga';

  @override
  String get passwordLengthError => 'Ijambo ry\'ibanga rigomba kuba rirenze inyuguti 8';

  @override
  String get passwordUppercaseError => 'Ijambo ry\'ibanga rigomba kugira byibura inyuguti nkuru imwe';

  @override
  String get passwordLowercaseError => 'Ijambo ry\'ibanga rigomba kugira byibura inyuguti nto imwe';

  @override
  String get passwordNumberError => 'Ijambo ry\'ibanga rigomba kugira umubare';

  @override
  String get passwordSpecialCharError => 'Ijambo ry\'ibanga rigomba kugira byibura akamenyetso kamwe kidasanzwe';

  @override
  String get passwordMismatchError => 'Amajambo y\'ibanga ntiyemewe';

  @override
  String get passwordResetSuccess => 'Ijambo ry\'ibanga ryawe ryongeweho neza';

  @override
  String get genericError => 'An error occurred';

  @override
  String get termsAndConditionsText => 'Amategeko n\'Amabwiriza';

  @override
  String get termsPageTitle => 'Amategeko n\'Amabwiriza';

  @override
  String get errorLoadingTerms => 'Ikibazo mu gukurura amategeko n\'amabwiriza';

  @override
  String get errorLoadingPage => 'Ntabwo kubona amakuru';

  @override
  String get selectLanguageTitle => 'Hitamo Ururimi';

  @override
  String get bottomNavHome => 'Ahabanza';

  @override
  String get bottomNavProfile => 'Umwirondoro';

  @override
  String get bottomNavLanguage => 'Ururimi';

  @override
  String get homePageTitle => 'Ahabanza';

  @override
  String get welcomeBackSubtitle => 'Cunga neza ibikoresho by\'umutekano wo kwirinda inkongi y\'umuriro';

  @override
  String get quickActionsTitle => 'Ibikorwa Byihuse';

  @override
  String get actionCardInventory => 'ububiko';

  @override
  String get actionCardServices => 'Serivisi';

  @override
  String get actionCardSettings => 'Amahitamo';

  @override
  String get actionCardNotifications => 'Ubutumwa';

  @override
  String get actionCardNavigation => 'Kuyobora';

  @override
  String get statusTitle => 'Imiterere';

  @override
  String get roleLabel => 'Uruhare';

  @override
  String get notificationsTooltip => 'Ubutumwa';

  @override
  String get confirmLogoutTitle => 'Emeza Gusohoka';

  @override
  String get confirmLogoutMessage => 'Urifuza gusohoka?';

  @override
  String get cancelButton => 'Kureka';

  @override
  String get logoutButton => 'Gusohoka';

  @override
  String get drawerMenuTitle => 'MENU';

  @override
  String get drawerFeaturesTitle => 'IBIKORWA';

  @override
  String get drawerOtherTitle => 'IBINDI';

  @override
  String get drawerItemDashboard => 'Ijambo ry\'ibikorwa';

  @override
  String get drawerItemHome => 'Ahabanza';

  @override
  String get drawerItemUsers => 'Abakoresha';

  @override
  String get drawerItemService => 'Serivisi';

  @override
  String get drawerItemInventory => 'Urubiko';

  @override
  String get drawerItemNavigation => 'Kuyobora';

  @override
  String get drawerItemProfile => 'Umwirondoro';

  @override
  String get drawerItemSettings => 'Amahitamo';

  @override
  String get drawerItemNotifications => 'Ubutumwa';
}
