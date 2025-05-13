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
}
