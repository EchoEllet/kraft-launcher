// dart format off
// coverage:ignore-file

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get settings => 'Einstellungen';

  @override
  String get home => 'Startseite';

  @override
  String get profiles => 'Profile';

  @override
  String get accounts => 'Konten';

  @override
  String get about => 'Über';

  @override
  String get switchAccount => 'Konto wechseln';

  @override
  String get play => 'Spielen';

  @override
  String get addAccount => 'Konto hinzufügen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get microsoft => 'Microsoft';

  @override
  String get offline => 'Offline';

  @override
  String get signInWithMicrosoft => 'Mit Microsoft anmelden';

  @override
  String get addMicrosoftAccount => 'Microsoft-Konto hinzufügen';

  @override
  String get copyCode => 'Code kopieren';

  @override
  String get copiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get deviceCodeStepVisit => '1. Besuche';

  @override
  String get deviceCodeStepEnter => '2. Gib den folgenden Code ein:';

  @override
  String get deviceCodeQrInstruction => 'Scanne, um den Link auf einem anderen Gerät zu öffnen.\nDu musst auch den obigen Code eingeben.';

  @override
  String get loggingInWithMicrosoftAccount => 'Anmeldung mit Microsoft-Konto';

  @override
  String get authProgressWaitingForUserLogin => 'Warte auf Benutzerauthentifizierung...';

  @override
  String get authProgressExchangingAuthCode => 'Austausch des Autorisierungscodes...';

  @override
  String get authProgressRequestingXboxLiveToken => 'Zugriff auf Xbox Live anfordern...';

  @override
  String get authProgressRequestingXstsToken => 'Xbox Live-Sitzung autorisieren...';

  @override
  String get authProgressLoggingIntoMinecraft => 'Anmeldung bei Minecraft-Diensten...';

  @override
  String get authProgressFetchingMinecraftProfile => 'Minecraft-Profil abrufen...';

  @override
  String loginSuccessAccountAddedMessage(String username) {
    return 'Hallo, $username! Du hast dich erfolgreich bei Minecraft angemeldet.';
  }

  @override
  String loginSuccessAccountUpdatedMessage(String username) {
    return 'Willkommen zurück, $username! Deine Kontodaten wurden aktualisiert.';
  }

  @override
  String get username => 'Benutzername';

  @override
  String get accountType => 'Kontotyp';

  @override
  String get removeAccount => 'Konto entfernen';

  @override
  String unexpectedError(String message) {
    return 'Unerwarteter Fehler: $message.';
  }

  @override
  String get unexpectedFailureMessage => 'Something went wrong. Please try again.';

  @override
  String get minecraftServicesLoginUnhandledServerResponse => 'Login failed due to an error from Minecraft services. Please try again.';

  @override
  String get minecraftServicesLoginInternalServerError => 'Login failed due to an internal server error from Minecraft services. Please try again.';

  @override
  String get minecraftServicesLoginUnexpectedResponseDataStructure => 'Login failed due to an unexpected response structure from Minecraft services. Please make sure the launcher is up to date and try again.';

  @override
  String get minecraftServicesLoginInvalidResponse => 'Login failed due to an invalid response from Minecraft services. Please try again later.';

  @override
  String get missingAuthCodeError => 'Es wurde kein Autorisierungscode angegeben. Die Anmeldung muss neu gestartet werden.';

  @override
  String get expiredAuthCodeError => 'Der Autorisierungscode ist abgelaufen. Bitte starte den Anmeldevorgang neu.';

  @override
  String get expiredMicrosoftAccessTokenError => 'Das OAuth-Zugriffstoken für Microsoft ist abgelaufen. Bitte melde dich erneut an.';

  @override
  String get unauthorizedMinecraftAccessError => 'Nicht autorisierter Zugriff auf Minecraft. Autorisierung ist abgelaufen oder ungültig.';

  @override
  String get createOfflineAccount => 'Offline-Konto erstellen';

  @override
  String get updateOfflineAccount => 'Offline-Konto aktualisieren';

  @override
  String get offlineMinecraftAccountCreationNotice => 'Gib einen gewünschten Minecraft-Benutzernamen ein. Offline-Konten werden lokal gespeichert und können keine Online-Server oder Realms nutzen.';

  @override
  String get create => 'Erstellen';

  @override
  String get minecraftUsernameHint => 'Beispiel: Steve';

  @override
  String get usernameEmptyError => 'Benutzername darf nicht leer sein';

  @override
  String get usernameTooShortError => 'Benutzername muss mindestens 3 Zeichen lang sein';

  @override
  String get usernameTooLongError => 'Benutzername darf maximal 16 Zeichen lang sein';

  @override
  String get usernameInvalidCharactersError => 'Benutzername darf nur Buchstaben, Zahlen und Unterstriche (_) enthalten.';

  @override
  String get usernameContainsWhitespacesError => 'Benutzername darf keine Leerzeichen enthalten.';

  @override
  String get update => 'Aktualisieren';

  @override
  String get minecraftId => 'Minecraft-ID';

  @override
  String get removeAccountConfirmation => 'Konto wirklich entfernen?';

  @override
  String get removeAccountConfirmationNotice => 'Dieses Konto wird aus dem Launcher entfernt.\nDu musst es erneut hinzufügen, um damit zu spielen.';

  @override
  String get remove => 'Entfernen';

  @override
  String get chooseYourPreferredLanguage => 'Wähle deine bevorzugte Sprache';

  @override
  String get appLanguage => 'App-Sprache';

  @override
  String get system => 'System';

  @override
  String get themeMode => 'Designmodus';

  @override
  String get selectDarkLightOrSystemTheme => 'Wähle zwischen dunklem, hellem oder systemeigenem Design';

  @override
  String get classicMaterialDesign => 'Klassisches Material Design';

  @override
  String get useClassicMaterialDesignTheme => 'Klassisches Material Design verwenden';

  @override
  String get dynamicColor => 'Dynamische Farben';

  @override
  String get automaticallyAdaptToSystemColors => 'Automatisch an Systemfarben anpassen';

  @override
  String get general => 'Allgemein';

  @override
  String get java => 'Java';

  @override
  String get launcher => 'Launcher';

  @override
  String get advanced => 'Erweitert';

  @override
  String get appearance => 'Darstellung';

  @override
  String get dark => 'Dunkel';

  @override
  String get light => 'Hell';

  @override
  String get customAccentColor => 'Benutzerdefinierte Akzentfarbe';

  @override
  String get customizeAccentColor => 'Passen Sie die Akzentfarbe des App-Themes an.';

  @override
  String get pickAColor => 'Farbe auswählen';

  @override
  String get close => 'Schließen';

  @override
  String get or => 'ODER';

  @override
  String get loginDeviceCodeExpired => 'Der Login-Code ist abgelaufen. Bitte versuche es erneut.';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get uiPreferences => 'UI-Einstellungen';

  @override
  String get defaultTab => 'Standard-Tab';

  @override
  String get initialTabSelectionDescription => 'Wählen Sie den Tab, der beim Start der App zuerst angezeigt wird';

  @override
  String get search => 'Suche';

  @override
  String get refreshAccount => 'Konto aktualisieren';

  @override
  String get sessionExpiredOrAccessRevoked => 'Die Sitzung des Kontos ist abgelaufen oder der Zugriff wurde widerrufen. Bitte melde dich erneut an, um fortzufahren.';

  @override
  String accountRefreshedMessage(String username) {
    return 'Das Konto für $username wurde erfolgreich aktualisiert.';
  }

  @override
  String get revokeAccess => 'Zugriff widerrufen';

  @override
  String get microsoftRequestLimitError => 'Anforderungsgrenze erreicht beim Kommunizieren mit den Microsoft-Authentifizierungsservern. Bitte versuche es in Kürze erneut.';

  @override
  String get authProgressRefreshingMicrosoftTokens => 'Microsoft-Tokens werden aktualisiert...';

  @override
  String get authProgressCheckingMinecraftJavaOwnership => 'Überprüfe Minecraft Java-Besitz...';

  @override
  String get waitForOngoingTask => 'Bitte warte, während die aktuelle Aufgabe abgeschlossen wird.';

  @override
  String get accountsEmptyTitle => 'Minecraft-Konten verwalten';

  @override
  String get accountsEmptySubtitle => 'Füge Minecraft-Konten hinzu, um nahtlos zu wechseln. Konten werden sicher auf diesem Gerät gespeichert.';

  @override
  String get authCodeRedirectPageLoginSuccessTitle => 'Erfolgreiche Anmeldung';

  @override
  String authCodeRedirectPageLoginSuccessMessage(String launcherName) {
    return 'Du hast dich erfolgreich bei $launcherName mit deinem Microsoft-Konto angemeldet. Du kannst dieses Fenster nun schließen.';
  }

  @override
  String get errorOccurred => 'Ein Fehler ist aufgetreten';

  @override
  String get reportBug => 'Fehler melden';

  @override
  String get unknownErrorWhileLoadingAccounts => 'Ein unbekannter Fehler ist beim Laden der Konten aufgetreten. Bitte versuchen Sie es später erneut.';

  @override
  String get minecraftRequestLimitError => 'Anfrage-Limit erreicht beim Kommunizieren mit den Minecraft-Servern. Bitte versuchen Sie es in Kürze erneut.';

  @override
  String unexpectedMicrosoftApiError(Object message) {
    return 'Unerwarteter Fehler bei der Kommunikation mit den Microsoft-Servern: $message. Bitte versuchen Sie es später erneut.';
  }

  @override
  String errorLoadingNetworkImage(Object message) {
    return 'Fehler beim Laden des Bildes: $message';
  }

  @override
  String get skinModelClassic => 'Klassisch';

  @override
  String get skinModelSlim => 'Slim';

  @override
  String get skinModel => 'Skin-Modell';

  @override
  String get updateSkin => 'Skin aktualisieren';

  @override
  String get featureUnsupportedYet => 'Diese Funktion wird noch nicht unterstützt. Bleiben Sie dran für zukünftige Updates!';

  @override
  String get news => 'Nachrichten';

  @override
  String legalDisclaimerMessage(String launcherName) {
    return '$launcherName ist KEIN OFFIZIELLES MINECRAFT-PRODUKT. Es ist NICHT VON MOJANG ODER MICROSOFT GENEHMIGT ODER MIT IHNEN VERBUNDEN.';
  }

  @override
  String get support => 'Support';

  @override
  String get website => 'Website';

  @override
  String get contact => 'Kontakt';

  @override
  String get askQuestion => 'Frage stellen';

  @override
  String get license => 'Lizenz';

  @override
  String get sourceCode => 'Source Code';

  @override
  String get invalidMinecraftSkinFile => 'Ungültiges Hautbild. Bitte laden Sie eine gültige Minecraft-Skin-Datei hoch.';

  @override
  String get manageSkins => 'Manage Skins';

  @override
  String get xstsUnknownError => 'Xbox sign-in failed. Please try again.';

  @override
  String xstsUnknownErrorWithDetails(String xErr, String apiMessage) {
    return 'Xbox sign-in failed. Error code: $xErr. Message: $apiMessage. Please try again.';
  }

  @override
  String get xstsAccountCreationRequiredError => 'This account is not linked to Xbox services. Please sign in to Xbox to continue.';

  @override
  String get xstsRegionNotSupportedError => 'Xbox Live isn\'t available in your Microsoft account\'s region.';

  @override
  String get xstsAdultVerificationRequiredError => 'Your Microsoft account needs adult verification.';

  @override
  String get xstsAgeVerificationRequiredError => 'Your Microsoft account needs age verification.';

  @override
  String get xstsRequiresAdultConsentRequiredError => 'This account is under 18. An adult needs to add the account to a Microsoft family group to continue.';

  @override
  String get xstsAccountBannedError => 'This Xbox account is permanently banned for violating community standards.';

  @override
  String get xstsTermsNotAcceptedError => 'This Microsoft account has not accepted the Xbox Terms of Service.';

  @override
  String get createXboxAccount => 'Create Xbox Account';

  @override
  String get minecraftAccountNotFoundError => 'Minecraft account was not found. Please ensure you are logged in with the correct Microsoft account.';

  @override
  String get minecraftOwnershipRequiredError => 'This Microsoft account does not have a valid Minecraft: Java Edition license. Please purchase or redeem the game to continue.';

  @override
  String get loginAttemptRejected => 'The login attempt was rejected.';

  @override
  String authCodeLoginUnknownError(String errorCode, String errorDescription) {
    return 'An unknown error occurred while logging in: $errorCode, $errorDescription';
  }

  @override
  String get minecraftJavaNotOwnedTitle => 'Minecraft: Java Edition Not Owned';

  @override
  String get visitMinecraftStore => 'Visit Store';

  @override
  String get redeemCode => 'Redeem';

  @override
  String get sessionExpired => 'The account session has expired. Please log in again to continue.';

  @override
  String get expired => 'Expired';

  @override
  String get revoked => 'Revoked';

  @override
  String reAuthRequiredDueToInactivity(int daysInactive) {
    return 'Your session has expired after $daysInactive days of inactivity. Please sign in again to continue.';
  }

  @override
  String get reAuthRequiredDueToAccessRevoked => 'Access to your account has been revoked. Please sign in again to continue.';

  @override
  String get signInViaBrowser => 'Sign in via Browser';

  @override
  String get reAuthRequiredDueToMissingSecureAccountDataDetailed => 'Secure account data is missing. This can happen if you\'re using a different system user, desktop environment, or operating system. Please sign in again to continue.';

  @override
  String get reAuthRequiredDueToMissingSecureAccountData => 'Secure account data is missing. Please sign in again to continue.';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get reAuthRequiredDueToMissingAccountTokensFromFileStorage => 'Account tokens are missing. Please sign in again to continue.';

  @override
  String get securityWarning => 'Security Warning';

  @override
  String get secureStorageUnsupportedWarning => 'Secure storage is not supported on this platform. Account tokens will be stored unencrypted in a local file. Be cautious with installed programs and Minecraft mods.';

  @override
  String get updateMicrosoftAccount => 'Update Microsoft Account';

  @override
  String get minecraftServicesApiUnavailable => 'Minecraft services are currently unavailable. Please try again in a few minutes.';

  @override
  String authCodeServerStartFailurePortInUse(int port) {
    return 'Unable to start the local server required for login. Port $port is already in use.';
  }

  @override
  String get authCodeServerStartFailurePermissionDenied => 'Unable to start the local server required for login due to system restrictions.';

  @override
  String get authCodeServerStartFailureUnexpected => 'Unable to start the local server required for login due to an unexpected error.';

  @override
  String get connectionFailure => 'Connection failed. Please check your internet connection and try again.';

  @override
  String get showErrorDetailsButton => 'Show details';

  @override
  String get technicalErrorDetailsDialogTitle => 'Technical details';
}
