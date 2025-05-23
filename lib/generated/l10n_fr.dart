import 'package:intl/intl.dart' as intl;

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

  @override
  String get termsAndConditionsText => 'En vous inscrivant, vous acceptez nos Conditions d\'utilisation et notre Politique de confidentialité.';

  @override
  String get termsPageTitle => 'Conditions d\'utilisation';

  @override
  String get errorLoadingTerms => 'Erreur lors du chargement des conditions d\'utilisation';

  @override
  String get errorLoadingPage => 'Error loading page. Please try again.';

  @override
  String get selectLanguageTitle => 'Sélectionner la langue';

  @override
  String get bottomNavHome => 'Accueil';

  @override
  String get bottomNavProfile => 'Profil';

  @override
  String get bottomNavLanguage => 'Langues';

  @override
  String get homePageTitle => 'Accueil';

  @override
  String get welcomeBackSubtitle => 'Gérez efficacement votre équipement de sécurité incendie';

  @override
  String get quickActionsTitle => 'Actions Rapides';

  @override
  String get actionCardInventory => 'Inventaire';

  @override
  String get actionCardServices => 'Serivisi';

  @override
  String get actionCardSettings => 'Paramètres';

  @override
  String get actionCardNotifications => 'Notifications';

  @override
  String get actionCardNavigation => 'Navigation';

  @override
  String get statusTitle => 'Statut';

  @override
  String get roleLabel => 'Rôle';

  @override
  String get notificationsTooltip => 'Notifications';

  @override
  String get confirmLogoutTitle => 'Confirmer la déconnexion';

  @override
  String get confirmLogoutMessage => 'Êtes-vous sûr(e) de vouloir vous déconnecter ?';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get logoutButton => 'Déconnexion';

  @override
  String get drawerMenuTitle => 'MENU';

  @override
  String get drawerFeaturesTitle => 'FONCTIONNALITÉS';

  @override
  String get drawerOtherTitle => 'AUTRES';

  @override
  String get drawerItemDashboard => 'Tableau de bord';

  @override
  String get drawerItemHome => 'Accueil';

  @override
  String get drawerItemUsers => 'Utilisateurs';

  @override
  String get drawerItemService => 'Service';

  @override
  String get drawerItemInventory => 'Inventaire';

  @override
  String get drawerItemNavigation => 'Navigation';

  @override
  String get drawerItemProfile => 'Profil';

  @override
  String get drawerItemSettings => 'Paramètres';

  @override
  String get drawerItemNotifications => 'Notifications';

  @override
  String get serviceRequestsTitle => 'Demandes de service';

  @override
  String get refreshTooltip => 'Actualiser';

  @override
  String get createServiceRequestTooltip => 'Créer une demande de service';

  @override
  String get searchServiceRequestsHint => 'Rechercher les demandes de service...';

  @override
  String get errorLoadingServiceRequests => 'Erreur lors du chargement des demandes de service';

  @override
  String get retryButton => 'Réessayer';

  @override
  String get noServiceRequestsFound => 'Aucune demande de service trouvée';

  @override
  String get adjustSearchOrFilters => 'Essayez d\'ajuster votre recherche ou vos filtres';

  @override
  String get columnTitle => 'TITRE';

  @override
  String get columnStatus => 'STATUT';

  @override
  String get columnTechnician => 'TECHNICIEN';

  @override
  String get columnDate => 'DATE';

  @override
  String get columnActions => 'ACTIONS';

  @override
  String get noTechnicianAssigned => 'Aucun technicien assigné';

  @override
  String get viewDetailsTooltip => 'Voir les détails';

  @override
  String get serviceRequestDetailsTitle => 'Détails de la demande de service';

  @override
  String get requestInformationTitle => 'Informations sur la demande';

  @override
  String get titleLabel => 'Titre';

  @override
  String get statusLabel => 'Statut';

  @override
  String get dateLabel => 'Date';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get clientInformationTitle => 'Informations client';

  @override
  String get emailLabel => 'Email';

  @override
  String get phoneLabel => 'Téléphone';

  @override
  String get technicianInformationTitle => 'Informations technicien';

  @override
  String get notAvailable => 'N/A';

  @override
  String get closeButton => 'Fermer';

  @override
  String showingRecords(Object startIndex, Object endIndex, Object totalCount, Object totalItems) {
    return 'Affichage de $startIndex-$endIndex sur $totalItems';
  }

  @override
  String get rowsLabel => 'Lignes : ';

  @override
  String get rowsPerPageLabel => 'Lignes par page : ';

  @override
  String get statusPending => 'En attente';

  @override
  String get statusInProgress => 'En cours';

  @override
  String get statusCompleted => 'Terminée';

  @override
  String get statusCancelled => 'Annulée';

  @override
  String get inventoryTitle => 'Inventaire';

  @override
  String get productCreatedSuccess => 'Produit créé avec succès';

  @override
  String errorCreatingProduct(Object error) {
    return 'Erreur lors de la création du produit : $error';
  }

  @override
  String get deleteProductTitle => 'Supprimer le produit';

  @override
  String deleteProductConfirmation(Object productName) {
    return 'Êtes-vous sûr de vouloir supprimer $productName ?';
  }

  @override
  String get deleteButton => 'Supprimer';

  @override
  String get productDeletedSuccess => 'Produit supprimé avec succès';

  @override
  String errorDeletingProduct(Object error) {
    return 'Erreur lors de la suppression du produit : $error';
  }

  @override
  String get productUpdatedSuccess => 'Produit mis à jour avec succès';

  @override
  String errorUpdatingProduct(Object error) {
    return 'Erreur lors de la mise à jour du produit : $error';
  }

  @override
  String failedToRefresh(Object error) {
    return 'Échec de l l\'actualisation : $error';
  }

  @override
  String get newButton => 'Nouveau';

  @override
  String get searchExtinguishersHint => 'Rechercher les extincteurs...';

  @override
  String get availableExtinguishersTitle => 'Extincteurs disponibles';

  @override
  String itemCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '$count élément',
      zero: 'Aucun élément',
    );
    return '$_temp0';
  }

  @override
  String get noExtinguishersAvailable => 'Aucun extincteur disponible';

  @override
  String get noExtinguishersMatchSearch => 'Aucun extincteur ne correspond à votre recherche';

  @override
  String get addExtinguisherButton => 'Ajouter un extincteur';

  @override
  String get unknownType => 'Type inconnu';

  @override
  String stockLabel(Object quantity) {
    return 'Stock : $quantity';
  }

  @override
  String get editTooltip => 'Modifier';

  @override
  String get deleteTooltip => 'Supprimer';

  @override
  String get errorLoadingProducts => 'Erreur lors du chargement des produits';

  @override
  String paginationPage(Object currentPage, Object totalPages) {
    return 'Page $currentPage sur $totalPages';
  }

  @override
  String get columnEmail => 'Email';

  @override
  String get columnPhone => 'Téléphone';

  @override
  String get columnRole => 'Rôle';

  @override
  String get locationLabel => 'Emplacement';

  @override
  String get statusVerified => 'Vérifié';

  @override
  String get statusUnverified => 'Non vérifié';

  @override
  String get userManagementTitle => 'Gestion des utilisateurs';

  @override
  String get userListRefreshed => 'Liste des utilisateurs actualisée';

  @override
  String get addUserTooltip => 'Ajouter un utilisateur';

  @override
  String get searchUsersHint => 'Rechercher des utilisateurs...';

  @override
  String get loadingMessage => 'Chargement des utilisateurs...';

  @override
  String get errorLoadingUsers => 'Erreur lors du chargement des utilisateurs';

  @override
  String get noUsersFound => 'Aucun utilisateur trouvé';

  @override
  String get noUsersMatchSearch => 'Aucun utilisateur ne correspond à votre recherche';

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
}
