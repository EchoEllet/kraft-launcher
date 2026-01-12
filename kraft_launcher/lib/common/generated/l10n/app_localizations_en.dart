// dart format off
// coverage:ignore-file

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get home => 'Home';

  @override
  String get profiles => 'Profiles';

  @override
  String get accounts => 'Accounts';

  @override
  String get about => 'About';

  @override
  String get switchAccount => 'Switch Account';

  @override
  String get play => 'Play';

  @override
  String get addAccount => 'Add Account';

  @override
  String get cancel => 'Cancel';

  @override
  String get microsoft => 'Microsoft';

  @override
  String get offline => 'Offline';

  @override
  String get signInWithMicrosoft => 'Sign in with Microsoft';

  @override
  String get addMicrosoftAccount => 'Add Microsoft Account';

  @override
  String get copyCode => 'Copy Code';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get deviceCodeStepVisit => '1. Visit';

  @override
  String get deviceCodeStepEnter => '2. Enter the code below:';

  @override
  String get deviceCodeQrInstruction => 'Scan to open the link on another device.\nYou’ll still need to enter the code above.';

  @override
  String get loggingInWithMicrosoftAccount => 'Logging in with Microsoft account';

  @override
  String get authProgressWaitingForUserLogin => 'Waiting for user authentication...';

  @override
  String get authProgressExchangingAuthCode => 'Exchanging authorization code...';

  @override
  String get authProgressRequestingXboxLiveToken => 'Requesting Xbox Live access...';

  @override
  String get authProgressRequestingXstsToken => 'Authorizing Xbox Live session...';

  @override
  String get authProgressLoggingIntoMinecraft => 'Logging into Minecraft services...';

  @override
  String get authProgressFetchingMinecraftProfile => 'Retrieving Minecraft profile...';

  @override
  String loginSuccessAccountAddedMessage(String username) {
    return 'Welcome, $username! You’re now signed in to Minecraft.';
  }

  @override
  String loginSuccessAccountUpdatedMessage(String username) {
    return 'Welcome back, $username! Your account details have been updated.';
  }

  @override
  String get username => 'Username';

  @override
  String get accountType => 'Account Type';

  @override
  String get removeAccount => 'Remove Account';

  @override
  String unexpectedError(String message) {
    return 'Unexpected error: $message.';
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
  String get missingAuthCodeError => 'Auth code not provided. Sign-in must be restarted.';

  @override
  String get expiredAuthCodeError => 'Auth code has expired. Please restart sign-in process.';

  @override
  String get expiredMicrosoftAccessTokenError => 'Microsoft OAuth access token expired. New sign-in required.';

  @override
  String get unauthorizedMinecraftAccessError => 'Unauthorized access to Minecraft. Authorization is expired or invalid.';

  @override
  String get createOfflineAccount => 'Create Offline Account';

  @override
  String get updateOfflineAccount => 'Update Offline Account';

  @override
  String get offlineMinecraftAccountCreationNotice => 'Enter your desired Minecraft username. Offline accounts are stored locally and can\'t access online servers or Realms.';

  @override
  String get create => 'Create';

  @override
  String get minecraftUsernameHint => 'e.g., Steve';

  @override
  String get usernameEmptyError => 'Username cannot be empty';

  @override
  String get usernameTooShortError => 'Username must be at least 3 characters';

  @override
  String get usernameTooLongError => 'Username must be at most 16 characters';

  @override
  String get usernameInvalidCharactersError => 'Username can only contain letters, numbers, and underscores.';

  @override
  String get usernameContainsWhitespacesError => 'Username cannot contain spaces.';

  @override
  String get update => 'Update';

  @override
  String get minecraftId => 'Minecraft ID';

  @override
  String get removeAccountConfirmation => 'Remove Account?';

  @override
  String get removeAccountConfirmationNotice => 'This account will be removed from the launcher.\nYou\'ll need to add it again to use it for playing.';

  @override
  String get remove => 'Remove';

  @override
  String get chooseYourPreferredLanguage => 'Choose your preferred language';

  @override
  String get appLanguage => 'App Language';

  @override
  String get system => 'System';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get selectDarkLightOrSystemTheme => 'Select dark, light, or system theme';

  @override
  String get classicMaterialDesign => 'Classic Material Design';

  @override
  String get useClassicMaterialDesignTheme => 'Use the classic Material Design theme';

  @override
  String get dynamicColor => 'Dynamic Color';

  @override
  String get automaticallyAdaptToSystemColors => 'Automatically adapt to the system colors';

  @override
  String get general => 'General';

  @override
  String get java => 'Java';

  @override
  String get launcher => 'Launcher';

  @override
  String get advanced => 'Advanced';

  @override
  String get appearance => 'Appearance';

  @override
  String get dark => 'Dark';

  @override
  String get light => 'Light';

  @override
  String get customAccentColor => 'Custom Accent Color';

  @override
  String get customizeAccentColor => 'Customize the accent color of the app theme.';

  @override
  String get pickAColor => 'Pick a Color';

  @override
  String get close => 'Close';

  @override
  String get or => 'OR';

  @override
  String get loginDeviceCodeExpired => 'The login code has expired. Please try again.';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get uiPreferences => 'UI Preferences';

  @override
  String get defaultTab => 'Default Tab';

  @override
  String get initialTabSelectionDescription => 'Choose the tab shown first when the app opens';

  @override
  String get search => 'Search';

  @override
  String get refreshAccount => 'Refresh Account';

  @override
  String get sessionExpiredOrAccessRevoked => 'The account session has expired or access was revoked. Please log in again to continue.';

  @override
  String accountRefreshedMessage(String username) {
    return 'Account for $username has been refreshed successfully.';
  }

  @override
  String get revokeAccess => 'Revoke Access';

  @override
  String get microsoftRequestLimitError => 'Request limit reached while communicating with Microsoft authentication servers. Please try again shortly.';

  @override
  String get authProgressRefreshingMicrosoftTokens => 'Refreshing Microsoft tokens...';

  @override
  String get authProgressCheckingMinecraftJavaOwnership => 'Checking Minecraft Java ownership...';

  @override
  String get waitForOngoingTask => 'Please hold on while the current task finishes.';

  @override
  String get accountsEmptyTitle => 'Manage Minecraft Accounts';

  @override
  String get accountsEmptySubtitle => 'Add Minecraft accounts for seamless switching. Accounts are stored securely on this device.';

  @override
  String get authCodeRedirectPageLoginSuccessTitle => 'Successful Login';

  @override
  String authCodeRedirectPageLoginSuccessMessage(String launcherName) {
    return 'You have successfully logged in to $launcherName using your Microsoft account. You can close this window.';
  }

  @override
  String get errorOccurred => 'An Error Occurred';

  @override
  String get reportBug => 'Report Bug';

  @override
  String get unknownErrorWhileLoadingAccounts => 'An unknown error occurred while loading the accounts. Please try again later.';

  @override
  String get minecraftRequestLimitError => 'Request limit reached while communicating with Minecraft servers. Please try again shortly.';

  @override
  String unexpectedMicrosoftApiError(Object message) {
    return 'Unexpected error while communicating with Microsoft servers: $message. Please try again later.';
  }

  @override
  String errorLoadingNetworkImage(Object message) {
    return 'An error occurred while loading the image: $message';
  }

  @override
  String get skinModelClassic => 'Classic';

  @override
  String get skinModelSlim => 'Slim';

  @override
  String get skinModel => 'Skin Model';

  @override
  String get updateSkin => 'Update Skin';

  @override
  String get featureUnsupportedYet => 'This feature is not supported yet. Stay tuned for future updates!';

  @override
  String get news => 'News';

  @override
  String legalDisclaimerMessage(String launcherName) {
    return '$launcherName is NOT AN OFFICIAL MINECRAFT PRODUCT. It is NOT APPROVED BY OR ASSOCIATED WITH MOJANG OR MICROSOFT.';
  }

  @override
  String get support => 'Support';

  @override
  String get website => 'Website';

  @override
  String get contact => 'Contact';

  @override
  String get askQuestion => 'Ask a question';

  @override
  String get license => 'License';

  @override
  String get sourceCode => 'Source Code';

  @override
  String get invalidMinecraftSkinFile => 'Invalid skin image. Please upload a valid Minecraft skin file.';

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
