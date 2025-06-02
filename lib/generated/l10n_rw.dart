import 'package:intl/intl.dart' as intl;

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
  String get genericError => 'Habayeho ikosa';

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
  String get notificationsTooltip => 'Ubutumwa';

  @override
  String get confirmLogoutTitle => 'Emeza Gusohoka';

  @override
  String get confirmLogoutMessage => 'Urifuza gusohoka?';

  @override
  String get cancelButton => 'Hagarika';

  @override
  String get logoutButton => 'Gusohoka';

  @override
  String get drawerMenuTitle => 'MENU';

  @override
  String get drawerFeaturesTitle => 'IBIKORWA';

  @override
  String get drawerOtherTitle => 'IBINDI';

  @override
  String get drawerItemDashboard => 'Ahabanza';

  @override
  String get drawerItemHome => 'Ahabanza';

  @override
  String get drawerItemUsers => 'Abakozi';

  @override
  String get drawerItemService => 'Serivisi';

  @override
  String get drawerItemInventory => 'ububiko';

  @override
  String get drawerItemNavigation => 'Kuyobora';

  @override
  String get drawerItemProfile => 'Umwirondoro';

  @override
  String get drawerItemSettings => 'Amahitamo';

  @override
  String get drawerItemNotifications => 'Ubutumwa';

  @override
  String get serviceRequestsTitle => ' Serivisi';

  @override
  String get refreshTooltip => 'Ongera utangire';

  @override
  String get createServiceRequestTooltip => 'Kora icyifuzo cya Serivisi';

  @override
  String get searchServiceRequestsHint => 'Shakisha  serivisi...';

  @override
  String get errorLoadingServiceRequests => 'Ikibazo mu gufata  serivisi';

  @override
  String get noServiceRequestsFound => 'Nta byifuzo bya Serivisi byabonetse';

  @override
  String get adjustSearchOrFilters => 'Gerageza guhindura uburyo bwo gushakisha cyangwa kugenwa';

  @override
  String get columnTitle => 'SERIVISI';

  @override
  String get columnStatus => 'Ahobigeze';

  @override
  String get columnTechnician => 'TEKINISIYE';

  @override
  String get columnDate => 'ITALIKI';

  @override
  String get columnActions => 'IBIKORWA';

  @override
  String get noTechnicianAssigned => 'Nta wasanze wagenwe';

  @override
  String get viewDetailsTooltip => 'Reba ibisobanuro';

  @override
  String get serviceRequestDetailsTitle => 'Serivisi Yasabwe';

  @override
  String get requestInformationTitle => 'Amakuru kuri serivisi';

  @override
  String get titleLabel => 'Umutwe';

  @override
  String get statusLabel => 'Umwanzuro';

  @override
  String get dateLabel => 'Italiki';

  @override
  String get descriptionLabel => 'Ibisobanuro';

  @override
  String get clientInformationTitle => 'Amakuru y\'Umukiriya';

  @override
  String get technicianInformationTitle => 'Amakuru y\'umutekinisiye';

  @override
  String get notAvailable => 'Ntibibonetse';

  @override
  String get closeButton => 'Funga';

  @override
  String get rowsLabel => 'Imirongo: ';

  @override
  String get rowsPerPageLabel => 'Imirongo kuri buri rupapuro: ';

  @override
  String get statusPending => 'Byategetswe';

  @override
  String get statusInProgress => 'Birimo gukorwa';

  @override
  String get statusCompleted => 'Byarangiye';

  @override
  String get statusCancelled => 'Byavanyweho';

  @override
  String get inventoryTitle => 'Ububiko';

  @override
  String get productCreatedSuccess => 'Produit yakozwe neza';

  @override
  String errorCreatingProduct(Object error) {
    return 'Ikibazo mu gukora produit : $error';
  }

  @override
  String get deleteProductTitle => 'Siba produit';

  @override
  String deleteProductConfirmation(Object productName) {
    return 'Wizeye ko ushaka gusiba $productName?';
  }

  @override
  String get deleteButton => 'Siba';

  @override
  String get productDeletedSuccess => 'Produit yasibwe neza';

  @override
  String errorDeletingProduct(Object error) {
    return 'Ikibazo mu gusiba produit : $error';
  }

  @override
  String get productUpdatedSuccess => 'Produit yavuguruwe neza';

  @override
  String errorUpdatingProduct(Object error) {
    return 'Ikibazo mu kuvugurura produit : $error';
  }

  @override
  String failedToRefresh(Object error) {
    return 'Kunanirwa gufata : $error';
  }

  @override
  String get newButton => 'Gishya';

  @override
  String get searchExtinguishersHint => 'Shakisha Kizimyamwoto...';

  @override
  String get availableExtinguishersTitle => 'Kizimyamwoto zihari';

  @override
  String itemCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ibikoresho',
      one: '$count ikikoresho',
      zero: 'Nta bikoresho bihari',
    );
    return '$_temp0';
  }

  @override
  String get noExtinguishersAvailable => 'Nta Kizimyamwoto zihari';

  @override
  String get noExtinguishersMatchSearch => 'Nta Kizimyamwoto bijyanye n\'ibyo ushakisha';

  @override
  String get addExtinguisherButton => 'Ongeraho Kizimyamwoto';

  @override
  String get unknownType => 'Ubwoko butazwi';

  @override
  String stockLabel(Object quantity) {
    return 'Ububiko: $quantity';
  }

  @override
  String get editTooltip => 'Hindura';

  @override
  String get deleteTooltip => 'Siba';

  @override
  String get errorLoadingProducts => 'Ikibazo mu gufata ibikoresho';

  @override
  String paginationPage(Object currentPage, Object totalPages) {
    return 'Urupapuro $currentPage rwa $totalPages';
  }

  @override
  String get columnEmail => 'Imeyili';

  @override
  String get columnPhone => 'Terefoni';

  @override
  String get columnRole => 'Uruhare';

  @override
  String get locationLabel => 'Aho aherereye';

  @override
  String get statusVerified => 'Yemejwe';

  @override
  String get statusUnverified => 'Ntiyemejwe';

  @override
  String get userManagementTitle => 'Ubuyobozi bw\'abakoresha';

  @override
  String get userListRefreshed => 'Amakuru y\'abakoresha yabonetse';

  @override
  String get addUserTooltip => 'Ongeza umukozi';

  @override
  String get searchUsersHint => 'Shakisha abakoresha...';

  @override
  String get errorLoadingUsers => 'Habayemo ikibazo';

  @override
  String get noUsersFound => 'Nta bakoresha babonetse';

  @override
  String get noUsersMatchSearch => 'Abo mwashatse ntabwo babonetse';

  @override
  String get loadingMessage => 'Gukura amakuru...';

  @override
  String showingRecords(Object startIndex, Object endIndex, Object totalCount, Object totalItems) {
    return '$startIndex-$endIndex / $totalItems';
  }

  @override
  String get requestForServiceTitle => 'Gusaba Serivisi';

  @override
  String get refillService => 'Serivisi yo kongera';

  @override
  String get maintenanceService => 'Serivisi yo gufata neza';

  @override
  String get supplyService => 'Serivisi yo gutanga ibikoresho';

  @override
  String get otherServices => 'Izindi Serivisi';

  @override
  String get selectServiceLabel => 'Hitamo Serivisi';

  @override
  String get selectTechnicianLabel => 'Hitamo Tekinisiye';

  @override
  String get pleaseSelectService => 'Nyamuneka hitamo serivisi';

  @override
  String get pleaseSelectTechnician => 'Nyamuneka hitamo tekinisiye';

  @override
  String get pleaseEnterDescription => 'Nyamuneka andika ibisobanuro';

  @override
  String get descriptionTooLong => 'Ibisobanuro birarenga (ntibigomba kurenga inyuguti 500)';

  @override
  String get describeServiceRequestHint => 'Sobanura ubusabe bwa serivisi yawe';

  @override
  String get unknownErrorOccurred => 'Ikosa ritazwi ryabayeho.';

  @override
  String get networkErrorOccurred => 'Ikosa ryabayeho kumurongo wa internet.';

  @override
  String get errorLoadingTechnicians => 'Ikosa ryabayeho mugutwara abatekinisiye.';

  @override
  String get noAvailableTechniciansFound => 'Nta batekinisiye bahari babonetse.';

  @override
  String failedToCreateRequest(Object errorMessage, Object error) {
    return 'Kurema ubusabe byarananiranye: $error';
  }

  @override
  String get submitButton => 'Kohereza';

  @override
  String get userNotAuthenticated => 'Ukoresha ntaho asangwa';

  @override
  String get translateServiceLabel => 'Serivisi yo guhindura';

  @override
  String get labelTextKey => 'Serivisi';

  @override
  String get loadingProfileMessage => 'Gukoresha amakuru...';

  @override
  String get errorLoadingProfile => 'Ikosa mu gukoresha amakuru';

  @override
  String get profileDataNotFound => 'Amakuru ntaho asangwa';

  @override
  String get profilePageTitle => 'Amakuru yanjye';

  @override
  String failedToUpdateProfileImage(Object error) {
    return 'Échec de la mise à jour de l\'image : $error';
  }

  @override
  String failedToRemoveProfileImage(Object error) {
    return 'Échec de la gukuraho l\'image : $error';
  }

  @override
  String get anonymousUserName => '____   _____';

  @override
  String get verifiedAccountLabel => 'Konti yemejwe';

  @override
  String get personalInformationTitle => 'Amakuru bwite';

  @override
  String get addressTitle => 'Aho aherereye';

  @override
  String get emailLabel => 'Email';

  @override
  String get phoneLabel => 'Nimero ya telefone';

  @override
  String get roleLabel => 'Uruhare';

  @override
  String get dateOfBirthLabel => 'Itariki y\'amavuko';

  @override
  String get streetLabel => 'Umuhanda';

  @override
  String get cityStateLabel => 'Umujyi/Intara';

  @override
  String get zipCodeLabel => 'Kode y\'iposita';

  @override
  String get notProvided => 'Ntabwo yatanze';

  @override
  String get retryButton => 'Ongera ugerageze';

  @override
  String get settingsTitle => 'Uburyo';

  @override
  String get profileSettingsSectionTitle => 'Amakuru';

  @override
  String get appSettingsSectionTitle => 'Uburyo bwa porogaramu';

  @override
  String get profileSettingsTitle => 'Uburyo bw\'amakuru';

  @override
  String get profileSettingsSubtitle => 'Vugurura amakuru bwite';

  @override
  String get changePasswordTitle => 'Hindura ijambo ry\'ibanga';

  @override
  String get changePasswordSubtitle => 'Genzura uburyo bw\'umutekano';

  @override
  String get languageTitle => 'Ururimi';

  @override
  String get languageSubtitle => 'Hindura ururimi rwa porogaramu';

  @override
  String get notifications_loadingUser => 'Umenyesha (Gutegura umukoresha...)';

  @override
  String get notifications_error => 'Umenyesha (Ikosa)';

  @override
  String get notifications_title => 'Amamenyesha';

  @override
  String get tooltip_showAll => 'Erekana Byose';

  @override
  String get tooltip_showUnread => 'Erekana Ibitarasomwa Gusa';

  @override
  String get menu_markAllAsRead => 'Marka Byose nka Byasomwe';

  @override
  String get menu_refresh => 'Subiramo';

  @override
  String get loading_userData => 'Gutegura amakuru y\'umukoresha...';

  @override
  String get loading_notifications => 'Gutegura umenyesha...';

  @override
  String get emptyState_unreadTitle => 'Nta menyesha ritarasomwa';

  @override
  String get emptyState_allTitle => 'Nta menyesha rirahari';

  @override
  String get emptyState_unreadSubtitle => 'Byose byamaze kuboneka! 🎉';

  @override
  String get emptyState_allSubtitle => 'Amamenyesha azagaragara hano';

  @override
  String get errorState_title => 'Kunanirwa gutegura umenyesha';

  @override
  String get errorState_retry => 'Ongera Ugerageze';

  @override
  String get delete_swipeAction => 'Siba';

  @override
  String get highPriority_label => 'Ubwihutirwe Bwinshi';

  @override
  String get date_justNow => 'Hashize akanya';

  @override
  String date_minutesAgo(Object minutes) {
    return 'Hashize iminota $minutes';
  }

  @override
  String date_hoursAgo(Object hours) {
    return 'Hashize amasaha $hours';
  }

  @override
  String date_daysAgo(Object days) {
    return 'Hashize iminsi $days';
  }

  @override
  String get deleteConfirmation_title => 'Siba';

  @override
  String deleteConfirmation_content(Object title) {
    return 'Uzi neza ko ushaka gusiba \"$title\"?';
  }

  @override
  String get button_cancel => 'Hagarika';

  @override
  String get button_delete => 'Gusiba';

  @override
  String get button_undo => 'Gusubizaho';

  @override
  String snackbar_notificationDeleted(Object title) {
    return 'Byasibwe \"$title\"';
  }

  @override
  String get snackbar_markedAllAsRead => 'Amamenyesha yose yemejwe nk\'ayasomwe';

  @override
  String get addTechnician_dialogTitle => 'Ongeraho umukozi mushya';

  @override
  String get textField_firstName => 'Izina rya mbere';

  @override
  String get textField_lastName => 'Izina rya nyuma';

  @override
  String get textField_email => 'Imeri';

  @override
  String get textField_phone => 'Terefoni';

  @override
  String get validation_firstNameRequired => 'Injiza izina rya mbere';

  @override
  String get validation_lastNameRequired => 'Injiza izina rya nyuma';

  @override
  String get validation_emailRequired => 'Injiza imeri';

  @override
  String get validation_emailValid => 'Injiza imeri iboneye';

  @override
  String get validation_phoneRequired => 'Injiza numero ya terefoni';

  @override
  String get button_create => 'Ohereza';

  @override
  String get button_creating => 'Kohereza...';

  @override
  String get error_requestTimedOut => 'Igihe cyo gusaba cyararangiye';

  @override
  String get error_prefix => 'Ikosa';

  @override
  String get snackbar_technicianCreatedSuccess => 'Umukozi yarezwe neza';

  @override
  String get snackbar_technicianCreatedError => 'Kurema umukozi byarananiranye';

  @override
  String get requestDateLabel => 'Itariki y\'isaba';

  @override
  String get completionDateLabel => 'Itariki yo kurangiza';

  @override
  String get requestedByLabel => 'Yasabye na';

  @override
  String get technicianLabel => 'Umuhanga';

  @override
  String get notesLabel => 'Ibisobanuro';

  @override
  String get unknown => 'Ntizwi';

  @override
  String get notSpecified => 'Ntibyatanzwe';

  @override
  String get updateServiceRequestStatus => 'Hagura Ubuzima bw\'isaba ry\'Ibarura';

  @override
  String get newStatusLabel => 'Ubuzima Bushya';

  @override
  String get updateButton => 'Hagura';

  @override
  String get updateStatusButton => 'Hagura Ubuzima';

  @override
  String statusUpdateSuccess(Object status) {
    return 'Ubuzima bw\'isaba ry\'ibarura bwagiye kuri $status.';
  }
}
