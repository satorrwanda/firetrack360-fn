import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class SFr extends S {
  SFr([String locale = 'fr']) : super(locale);

  @override
  String get onboardingTitle1 => 'Bienvenue à FireTrack360';

  @override
  String get onboardingDesc1 => 'Sécurisez votre monde, une touche à la fois';

  @override
  String get onboardingTitle2 => 'Commencer';

  @override
  String get onboardingDesc2 => 'Créez un compte ou connectez-vous pour accéder à toutes les fonctionnalités';

  @override
  String get onboardingTitle3 => 'Sécurisé et Simple';

  @override
  String get onboardingDesc3 => 'Simplifiez votre gestion de la sécurité';

  @override
  String get register => 'S\'inscrire';

  @override
  String get login => 'Se connecter';

  @override
  String get dontHaveAccountPrompt => 'Vous n\'avez pas de compte ?';

  @override
  String get signUpLink => 'S\'inscrire';

  @override
  String get welcomeBackTitle => 'Bon retour';

  @override
  String get signInToContinueSubtitle => 'Connectez-vous pour continuer';

  @override
  String get fillAllFieldsError => 'Veuillez remplir tous les champs';

  @override
  String get invalidEmailError => 'Veuillez saisir une adresse email valide';

  @override
  String get loginFailedDefaultError => 'Échec de la connexion';

  @override
  String get emailVerificationRequiredError => 'Veuillez vérifier votre adresse email avant de vous connecter';

  @override
  String get loginSuccessfulMessage => 'Connexion réussie !';

  @override
  String get emailSaveFailedError => 'Échec de l\'enregistrement de l\'email. Veuillez réessayer.';

  @override
  String get unexpectedError => 'Une erreur inattendue s\'est produite';

  @override
  String get emailHintText => 'Adresse email';

  @override
  String get passwordHintText => 'Mot de passe';

  @override
  String get forgotPasswordLink => 'Mot de passe oublié ?';
}
