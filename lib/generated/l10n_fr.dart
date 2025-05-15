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

  @override
  String get createAccountTitle => 'Créer un compte';

  @override
  String get signUpToGetStartedSubtitle => 'Inscrivez-vous pour commencer';

  @override
  String get enterPhoneNumberError => 'Veuillez saisir votre numéro de téléphone';

  @override
  String get rwandaPhoneNumberLengthError => 'Les numéros de téléphone au Rwanda doivent comporter 9 chiffres';

  @override
  String get rwandaPhoneNumberStartError => 'Les numéros de téléphone au Rwanda doivent commencer par 7';

  @override
  String get phoneNumberMinLengthError => 'Le numéro de téléphone doit comporter au moins 9 chiffres';

  @override
  String get phoneNumberMaxLengthError => 'Le numéro de téléphone ne peut pas dépasser 10 chiffres';

  @override
  String get enterPasswordError => 'Veuillez saisir un mot de passe';

  @override
  String get passwordMinLengthError => 'Le mot de passe doit comporter au moins 8 caractères';

  @override
  String get passwordDigitError => 'Le mot de passe doit contenir au moins un chiffre';

  @override
  String get confirmPasswordError => 'Veuillez confirmer votre mot de passe';

  @override
  String get passwordsDoNotMatchError => 'Les mots de passe ne correspondent pas';

  @override
  String get phoneNumberLabel => 'Numéro de téléphone';

  @override
  String get searchCountryHint => 'Rechercher un pays';

  @override
  String get confirmPasswordHintText => 'Confirmer le mot de passe';

  @override
  String get emailAlreadyRegisteredError => 'Cette adresse email est déjà enregistrée. Veuillez utiliser une adresse email différente ou essayer de vous connecter.';

  @override
  String get checkInformationError => 'Veuillez vérifier vos informations et réessayer.';

  @override
  String get invalidInputError => 'Saisie invalide. Veuillez vérifier vos détails.';

  @override
  String get connectionError => 'Impossible de se connecter au serveur. Veuillez vérifier votre connexion internet.';

  @override
  String get defaultError => 'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get successSnackBarTitle => 'Succès';

  @override
  String get errorSnackBarTitle => 'Erreur';

  @override
  String get dismissSnackBarAction => 'FERMER';

  @override
  String get registrationSuccessDefaultMessage => 'Inscription réussie ! Veuillez vérifier votre adresse email avec l\'OTP envoyé.';

  @override
  String get registrationFailedDefaultMessage => 'Échec de l\'inscription. Veuillez réessayer.';

  @override
  String get unexpectedAuthError => 'Une erreur inattendue s\'est produite. Veuillez réessayer plus tard.';

  @override
  String get loginFailedDefaultMessage => 'Échec de la connexion. Veuillez réessayer.';

  @override
  String get resendOtpSuccessDefaultMessage => 'Code de vérification renvoyé avec succès.';

  @override
  String get resendOtpFailedDefaultMessage => 'Échec du renvoi du code de vérification. Veuillez réessayer.';

  @override
  String get enterEmailError => 'Veuillez saisir votre adresse email';

  @override
  String get alreadyRegisteredPrompt => 'Déjà enregistré ?';

  @override
  String get loginLink => 'Se connecter';

  @override
  String get noEmailFoundError => 'Aucune adresse email trouvée. Veuillez vous reconnecter.';

  @override
  String get invalidEmailVerificationError => 'Adresse email invalide. Veuillez vous reconnecter.';

  @override
  String get errorRetrievingEmailError => 'Erreur lors de la récupération de l\'adresse email. Veuillez vous reconnecter.';

  @override
  String get verificationGraphQLErrorDefault => 'Une erreur s\'est produite';

  @override
  String get invalidLoginResponseError => 'Réponse de connexion invalide';

  @override
  String get verificationFailedDefault => 'Échec de la vérification';

  @override
  String unexpectedVerificationError(Object error) {
    return 'Une erreur inattendue s\'est produite : $error';
  }

  @override
  String get enterOtpError => 'Veuillez saisir l\'OTP';

  @override
  String get otpLengthError => 'L\'OTP doit comporter 6 chiffres';

  @override
  String get otpNumbersOnlyError => 'L\'OTP doit contenir uniquement des chiffres';

  @override
  String get verifyOtpTitle => 'Vérifier l\'OTP';

  @override
  String enterOtpMessage(Object maskedEmail) {
    return 'Saisissez le code de vérification envoyé à\n$maskedEmail';
  }

  @override
  String get otpHintText => 'Saisissez l\'OTP à 6 chiffres';

  @override
  String get verifyCodeButton => 'Vérifier le code';

  @override
  String get didNotReceiveCodePrompt => 'Vous n\'avez pas reçu le code ?';

  @override
  String get resendLink => 'Renvoyer';

  @override
  String get futureBuilderErrorPrefix => 'Erreur de construction';

  @override
  String get unexpectedPasswordResetVerificationError => 'Une erreur inattendue s\'est produite lors de la vérification de la réinitialisation du mot de passe';

  @override
  String get forgotPasswordTitle => 'Mot de passe oublié';

  @override
  String get enterEmailToResetPasswordSubtitle => 'Saisissez votre email pour réinitialiser le mot de passe';

  @override
  String get passwordResetOtpSentMessage => 'L\'OTP pour réinitialiser le mot de passe a été envoyé à votre adresse email.';

  @override
  String get rememberPasswordPrompt => 'Vous vous souvenez de votre mot de passe ?';

  @override
  String get signInLink => 'Se connecter';

  @override
  String get resetPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get resetPasswordSubtitle => 'Entrez votre nouveau mot de passe';

  @override
  String get newPasswordHint => 'Nouveau mot de passe';

  @override
  String get confirmPasswordHint => 'Confirmer le mot de passe';

  @override
  String get resetPasswordButton => 'Réinitialiser le mot de passe';

  @override
  String get passwordRequired => 'Veuillez entrer un mot de passe';

  @override
  String get passwordLengthError => 'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get passwordUppercaseError => 'Le mot de passe doit contenir au moins une majuscule';

  @override
  String get passwordLowercaseError => 'Le mot de passe doit contenir au moins une minuscule';

  @override
  String get passwordNumberError => 'Le mot de passe doit contenir au moins un chiffre';

  @override
  String get passwordSpecialCharError => 'Le mot de passe doit contenir au moins un caractère spécial';

  @override
  String get passwordMismatchError => 'Les mots de passe ne correspondent pas';

  @override
  String get passwordResetSuccess => 'Votre mot de passe a été réinitialisé avec succès';

  @override
  String get genericError => 'Une erreur s\'est produite';
}
