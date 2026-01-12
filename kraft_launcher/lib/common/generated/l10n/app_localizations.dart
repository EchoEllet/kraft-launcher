// dart format off
// coverage:ignore-file
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profiles.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get profiles;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @switchAccount.
  ///
  /// In en, this message translates to:
  /// **'Switch Account'**
  String get switchAccount;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @addAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get addAccount;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @microsoft.
  ///
  /// In en, this message translates to:
  /// **'Microsoft'**
  String get microsoft;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @signInWithMicrosoft.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Microsoft'**
  String get signInWithMicrosoft;

  /// No description provided for @addMicrosoftAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Microsoft Account'**
  String get addMicrosoftAccount;

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy Code'**
  String get copyCode;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @deviceCodeStepVisit.
  ///
  /// In en, this message translates to:
  /// **'1. Visit'**
  String get deviceCodeStepVisit;

  /// No description provided for @deviceCodeStepEnter.
  ///
  /// In en, this message translates to:
  /// **'2. Enter the code below:'**
  String get deviceCodeStepEnter;

  /// No description provided for @deviceCodeQrInstruction.
  ///
  /// In en, this message translates to:
  /// **'Scan to open the link on another device.\nYou’ll still need to enter the code above.'**
  String get deviceCodeQrInstruction;

  /// No description provided for @loggingInWithMicrosoftAccount.
  ///
  /// In en, this message translates to:
  /// **'Logging in with Microsoft account'**
  String get loggingInWithMicrosoftAccount;

  /// No description provided for @authProgressWaitingForUserLogin.
  ///
  /// In en, this message translates to:
  /// **'Waiting for user authentication...'**
  String get authProgressWaitingForUserLogin;

  /// No description provided for @authProgressExchangingAuthCode.
  ///
  /// In en, this message translates to:
  /// **'Exchanging authorization code...'**
  String get authProgressExchangingAuthCode;

  /// No description provided for @authProgressRequestingXboxLiveToken.
  ///
  /// In en, this message translates to:
  /// **'Requesting Xbox Live access...'**
  String get authProgressRequestingXboxLiveToken;

  /// No description provided for @authProgressRequestingXstsToken.
  ///
  /// In en, this message translates to:
  /// **'Authorizing Xbox Live session...'**
  String get authProgressRequestingXstsToken;

  /// No description provided for @authProgressLoggingIntoMinecraft.
  ///
  /// In en, this message translates to:
  /// **'Logging into Minecraft services...'**
  String get authProgressLoggingIntoMinecraft;

  /// No description provided for @authProgressFetchingMinecraftProfile.
  ///
  /// In en, this message translates to:
  /// **'Retrieving Minecraft profile...'**
  String get authProgressFetchingMinecraftProfile;

  /// Snackbar message shown after successful login to a Minecraft account using Microsoft authentication.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {username}! You’re now signed in to Minecraft.'**
  String loginSuccessAccountAddedMessage(String username);

  /// Snackbar message shown when logging in with a Microsoft account that was previously added. Indicates that the account info has been refreshed or updated.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {username}! Your account details have been updated.'**
  String loginSuccessAccountUpdatedMessage(String username);

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountType;

  /// No description provided for @removeAccount.
  ///
  /// In en, this message translates to:
  /// **'Remove Account'**
  String get removeAccount;

  /// (DEPRECATED, use unexpectedFailureMessage instead) Fallback error message for unexpected errors during any operation.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error: {message}.'**
  String unexpectedError(String message);

  /// Fallback message shown to the user when an unexpected exception occurs that was not specifically handled. This is not meant to indicate a bug in the app, but to provide a generic, user-friendly message for recoverable issues or unknown exceptions.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get unexpectedFailureMessage;

  /// No description provided for @minecraftServicesLoginUnhandledServerResponse.
  ///
  /// In en, this message translates to:
  /// **'Login failed due to an error from Minecraft services. Please try again.'**
  String get minecraftServicesLoginUnhandledServerResponse;

  /// No description provided for @minecraftServicesLoginInternalServerError.
  ///
  /// In en, this message translates to:
  /// **'Login failed due to an internal server error from Minecraft services. Please try again.'**
  String get minecraftServicesLoginInternalServerError;

  /// No description provided for @minecraftServicesLoginUnexpectedResponseDataStructure.
  ///
  /// In en, this message translates to:
  /// **'Login failed due to an unexpected response structure from Minecraft services. Please make sure the launcher is up to date and try again.'**
  String get minecraftServicesLoginUnexpectedResponseDataStructure;

  /// No description provided for @minecraftServicesLoginInvalidResponse.
  ///
  /// In en, this message translates to:
  /// **'Login failed due to an invalid response from Minecraft services. Please try again later.'**
  String get minecraftServicesLoginInvalidResponse;

  /// Shown when the login process is redirected without a 'code' parameter, indicating that the Microsoft authorization code is missing or was manually accessed.
  ///
  /// In en, this message translates to:
  /// **'Auth code not provided. Sign-in must be restarted.'**
  String get missingAuthCodeError;

  /// Shown when the Microsoft authorization code is no longer valid due to timeout or reuse.
  ///
  /// In en, this message translates to:
  /// **'Auth code has expired. Please restart sign-in process.'**
  String get expiredAuthCodeError;

  /// Shown when the Microsoft access token used to fetch Xbox token.
  ///
  /// In en, this message translates to:
  /// **'Microsoft OAuth access token expired. New sign-in required.'**
  String get expiredMicrosoftAccessTokenError;

  /// Shown when the Minecraft API returns an unauthorized access response (HTTP 401), usually because the Minecraft access token is expired or invalid.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access to Minecraft. Authorization is expired or invalid.'**
  String get unauthorizedMinecraftAccessError;

  /// No description provided for @createOfflineAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Offline Account'**
  String get createOfflineAccount;

  /// No description provided for @updateOfflineAccount.
  ///
  /// In en, this message translates to:
  /// **'Update Offline Account'**
  String get updateOfflineAccount;

  /// No description provided for @offlineMinecraftAccountCreationNotice.
  ///
  /// In en, this message translates to:
  /// **'Enter your desired Minecraft username. Offline accounts are stored locally and can\'t access online servers or Realms.'**
  String get offlineMinecraftAccountCreationNotice;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Example Minecraft username, shown as a hint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Steve'**
  String get minecraftUsernameHint;

  /// No description provided for @usernameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Username cannot be empty'**
  String get usernameEmptyError;

  /// No description provided for @usernameTooShortError.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get usernameTooShortError;

  /// No description provided for @usernameTooLongError.
  ///
  /// In en, this message translates to:
  /// **'Username must be at most 16 characters'**
  String get usernameTooLongError;

  /// No description provided for @usernameInvalidCharactersError.
  ///
  /// In en, this message translates to:
  /// **'Username can only contain letters, numbers, and underscores.'**
  String get usernameInvalidCharactersError;

  /// No description provided for @usernameContainsWhitespacesError.
  ///
  /// In en, this message translates to:
  /// **'Username cannot contain spaces.'**
  String get usernameContainsWhitespacesError;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @minecraftId.
  ///
  /// In en, this message translates to:
  /// **'Minecraft ID'**
  String get minecraftId;

  /// No description provided for @removeAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Remove Account?'**
  String get removeAccountConfirmation;

  /// No description provided for @removeAccountConfirmationNotice.
  ///
  /// In en, this message translates to:
  /// **'This account will be removed from the launcher.\nYou\'ll need to add it again to use it for playing.'**
  String get removeAccountConfirmationNotice;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @chooseYourPreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get chooseYourPreferredLanguage;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @selectDarkLightOrSystemTheme.
  ///
  /// In en, this message translates to:
  /// **'Select dark, light, or system theme'**
  String get selectDarkLightOrSystemTheme;

  /// No description provided for @classicMaterialDesign.
  ///
  /// In en, this message translates to:
  /// **'Classic Material Design'**
  String get classicMaterialDesign;

  /// No description provided for @useClassicMaterialDesignTheme.
  ///
  /// In en, this message translates to:
  /// **'Use the classic Material Design theme'**
  String get useClassicMaterialDesignTheme;

  /// No description provided for @dynamicColor.
  ///
  /// In en, this message translates to:
  /// **'Dynamic Color'**
  String get dynamicColor;

  /// No description provided for @automaticallyAdaptToSystemColors.
  ///
  /// In en, this message translates to:
  /// **'Automatically adapt to the system colors'**
  String get automaticallyAdaptToSystemColors;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @java.
  ///
  /// In en, this message translates to:
  /// **'Java'**
  String get java;

  /// No description provided for @launcher.
  ///
  /// In en, this message translates to:
  /// **'Launcher'**
  String get launcher;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @customAccentColor.
  ///
  /// In en, this message translates to:
  /// **'Custom Accent Color'**
  String get customAccentColor;

  /// No description provided for @customizeAccentColor.
  ///
  /// In en, this message translates to:
  /// **'Customize the accent color of the app theme.'**
  String get customizeAccentColor;

  /// No description provided for @pickAColor.
  ///
  /// In en, this message translates to:
  /// **'Pick a Color'**
  String get pickAColor;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @loginDeviceCodeExpired.
  ///
  /// In en, this message translates to:
  /// **'The login code has expired. Please try again.'**
  String get loginDeviceCodeExpired;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @uiPreferences.
  ///
  /// In en, this message translates to:
  /// **'UI Preferences'**
  String get uiPreferences;

  /// No description provided for @defaultTab.
  ///
  /// In en, this message translates to:
  /// **'Default Tab'**
  String get defaultTab;

  /// No description provided for @initialTabSelectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the tab shown first when the app opens'**
  String get initialTabSelectionDescription;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @refreshAccount.
  ///
  /// In en, this message translates to:
  /// **'Refresh Account'**
  String get refreshAccount;

  /// Shown when a request to Microsoft API was sent but then server responds with invalid_grant because either the refresh token was expired or access revoked by the user.
  ///
  /// In en, this message translates to:
  /// **'The account session has expired or access was revoked. Please log in again to continue.'**
  String get sessionExpiredOrAccessRevoked;

  /// Message shown when the user refreshes an account. Includes the username.
  ///
  /// In en, this message translates to:
  /// **'Account for {username} has been refreshed successfully.'**
  String accountRefreshedMessage(String username);

  /// No description provided for @revokeAccess.
  ///
  /// In en, this message translates to:
  /// **'Revoke Access'**
  String get revokeAccess;

  /// No description provided for @microsoftRequestLimitError.
  ///
  /// In en, this message translates to:
  /// **'Request limit reached while communicating with Microsoft authentication servers. Please try again shortly.'**
  String get microsoftRequestLimitError;

  /// No description provided for @authProgressRefreshingMicrosoftTokens.
  ///
  /// In en, this message translates to:
  /// **'Refreshing Microsoft tokens...'**
  String get authProgressRefreshingMicrosoftTokens;

  /// Message shown when the system is checking the user's Minecraft Java ownership status.
  ///
  /// In en, this message translates to:
  /// **'Checking Minecraft Java ownership...'**
  String get authProgressCheckingMinecraftJavaOwnership;

  /// No description provided for @waitForOngoingTask.
  ///
  /// In en, this message translates to:
  /// **'Please hold on while the current task finishes.'**
  String get waitForOngoingTask;

  /// No description provided for @accountsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Minecraft Accounts'**
  String get accountsEmptyTitle;

  /// No description provided for @accountsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add Minecraft accounts for seamless switching. Accounts are stored securely on this device.'**
  String get accountsEmptySubtitle;

  /// No description provided for @authCodeRedirectPageLoginSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Successful Login'**
  String get authCodeRedirectPageLoginSuccessTitle;

  /// Message displayed on the HTML page or redirect page after a successful login via Microsoft account using the authentication code.
  ///
  /// In en, this message translates to:
  /// **'You have successfully logged in to {launcherName} using your Microsoft account. You can close this window.'**
  String authCodeRedirectPageLoginSuccessMessage(String launcherName);

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An Error Occurred'**
  String get errorOccurred;

  /// No description provided for @reportBug.
  ///
  /// In en, this message translates to:
  /// **'Report Bug'**
  String get reportBug;

  /// No description provided for @unknownErrorWhileLoadingAccounts.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred while loading the accounts. Please try again later.'**
  String get unknownErrorWhileLoadingAccounts;

  /// No description provided for @minecraftRequestLimitError.
  ///
  /// In en, this message translates to:
  /// **'Request limit reached while communicating with Minecraft servers. Please try again shortly.'**
  String get minecraftRequestLimitError;

  /// No description provided for @unexpectedMicrosoftApiError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error while communicating with Microsoft servers: {message}. Please try again later.'**
  String unexpectedMicrosoftApiError(Object message);

  /// No description provided for @errorLoadingNetworkImage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading the image: {message}'**
  String errorLoadingNetworkImage(Object message);

  /// No description provided for @skinModelClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get skinModelClassic;

  /// No description provided for @skinModelSlim.
  ///
  /// In en, this message translates to:
  /// **'Slim'**
  String get skinModelSlim;

  /// No description provided for @skinModel.
  ///
  /// In en, this message translates to:
  /// **'Skin Model'**
  String get skinModel;

  /// No description provided for @updateSkin.
  ///
  /// In en, this message translates to:
  /// **'Update Skin'**
  String get updateSkin;

  /// No description provided for @featureUnsupportedYet.
  ///
  /// In en, this message translates to:
  /// **'This feature is not supported yet. Stay tuned for future updates!'**
  String get featureUnsupportedYet;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// A legal disclaimer displayed to the user informing them that the launcher is not an official Minecraft product and is not associated with Mojang or Microsoft.
  ///
  /// In en, this message translates to:
  /// **'{launcherName} is NOT AN OFFICIAL MINECRAFT PRODUCT. It is NOT APPROVED BY OR ASSOCIATED WITH MOJANG OR MICROSOFT.'**
  String legalDisclaimerMessage(String launcherName);

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @askQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a question'**
  String get askQuestion;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @sourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source Code'**
  String get sourceCode;

  /// Shown when the user uploads an invalid Minecraft skin file.
  ///
  /// In en, this message translates to:
  /// **'Invalid skin image. Please upload a valid Minecraft skin file.'**
  String get invalidMinecraftSkinFile;

  /// No description provided for @manageSkins.
  ///
  /// In en, this message translates to:
  /// **'Manage Skins'**
  String get manageSkins;

  /// Shown when the XSTS authentication fails for an unknown reason.
  ///
  /// In en, this message translates to:
  /// **'Xbox sign-in failed. Please try again.'**
  String get xstsUnknownError;

  /// Shown when the XSTS authentication fails for an unknown reason, including the error code and message from the API.
  ///
  /// In en, this message translates to:
  /// **'Xbox sign-in failed. Error code: {xErr}. Message: {apiMessage}. Please try again.'**
  String xstsUnknownErrorWithDetails(String xErr, String apiMessage);

  /// Shown when the user tries to log in but doesn't have an Xbox profile which is required for XSTS authorization. They need to visit https://start.ui.xboxlive.com/CreateAccount and sign in to create one.
  ///
  /// In en, this message translates to:
  /// **'This account is not linked to Xbox services. Please sign in to Xbox to continue.'**
  String get xstsAccountCreationRequiredError;

  /// Shown when the Xbox Live service is not available in the user's region according to their Microsoft account.
  ///
  /// In en, this message translates to:
  /// **'Xbox Live isn\'t available in your Microsoft account\'s region.'**
  String get xstsRegionNotSupportedError;

  /// Shown when the account requires adult verification before proceeding with sign-in.
  ///
  /// In en, this message translates to:
  /// **'Your Microsoft account needs adult verification.'**
  String get xstsAdultVerificationRequiredError;

  /// Shown when the account requires age verification before proceeding with sign-in.
  ///
  /// In en, this message translates to:
  /// **'Your Microsoft account needs age verification.'**
  String get xstsAgeVerificationRequiredError;

  /// Shown when the user needs to be added to a family group by an adult to access Xbox services. This is required for XSTS authorization due to age restrictions.
  ///
  /// In en, this message translates to:
  /// **'This account is under 18. An adult needs to add the account to a Microsoft family group to continue.'**
  String get xstsRequiresAdultConsentRequiredError;

  /// Shown when the user's Xbox account is permanently banned for violating community standards.
  ///
  /// In en, this message translates to:
  /// **'This Xbox account is permanently banned for violating community standards.'**
  String get xstsAccountBannedError;

  /// Shown when the user's Microsoft account has not accepted the Xbox Terms of Service, which prevents access to Xbox services through XSTS.
  ///
  /// In en, this message translates to:
  /// **'This Microsoft account has not accepted the Xbox Terms of Service.'**
  String get xstsTermsNotAcceptedError;

  /// No description provided for @createXboxAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Xbox Account'**
  String get createXboxAccount;

  /// Shown when the user successfully logs in with a Microsoft account, but no associated Minecraft profile is found. This may happen if the user has not purchased or redeemed the game.
  ///
  /// In en, this message translates to:
  /// **'Minecraft account was not found. Please ensure you are logged in with the correct Microsoft account.'**
  String get minecraftAccountNotFoundError;

  /// Shown when the Microsoft account is valid and a Minecraft profile may exist, but no active license for Minecraft is found. This may occur if the game has not been purchased or redeemed. Users can resolve this at https://www.minecraft.net/redeem or https://www.minecraft.net/store/minecraft-deluxe-collection-pc.
  ///
  /// In en, this message translates to:
  /// **'This Microsoft account does not have a valid Minecraft: Java Edition license. Please purchase or redeem the game to continue.'**
  String get minecraftOwnershipRequiredError;

  /// No description provided for @loginAttemptRejected.
  ///
  /// In en, this message translates to:
  /// **'The login attempt was rejected.'**
  String get loginAttemptRejected;

  /// Shown when an unknown error occurs while logging in with Microsoft via an auth code. The user logs in using the browser, and then Microsoft redirects the user to a minimal and local HTTP server to handle the result. This message is used when the error code is unknown.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred while logging in: {errorCode}, {errorDescription}'**
  String authCodeLoginUnknownError(String errorCode, String errorDescription);

  /// No description provided for @minecraftJavaNotOwnedTitle.
  ///
  /// In en, this message translates to:
  /// **'Minecraft: Java Edition Not Owned'**
  String get minecraftJavaNotOwnedTitle;

  /// No description provided for @visitMinecraftStore.
  ///
  /// In en, this message translates to:
  /// **'Visit Store'**
  String get visitMinecraftStore;

  /// No description provided for @redeemCode.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get redeemCode;

  /// Shown when the app detects that the Microsoft refresh token has expired (90 days since issuance) before making an HTTP request.
  ///
  /// In en, this message translates to:
  /// **'The account session has expired. Please log in again to continue.'**
  String get sessionExpired;

  /// Shown in the account list tile as a badge when the Microsoft refresh token has expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// Shown in the account list tile as a badge when the Microsoft refresh token access has been revoked.
  ///
  /// In en, this message translates to:
  /// **'Revoked'**
  String get revoked;

  /// Shown when the user has not signed in or used the account for a long time and the session has expired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired after {daysInactive} days of inactivity. Please sign in again to continue.'**
  String reAuthRequiredDueToInactivity(int daysInactive);

  /// Shown when access to the user's account has been explicitly revoked, such as by an administrator or by the user from account settings. The user must re-authenticate to continue.
  ///
  /// In en, this message translates to:
  /// **'Access to your account has been revoked. Please sign in again to continue.'**
  String get reAuthRequiredDueToAccessRevoked;

  /// No description provided for @signInViaBrowser.
  ///
  /// In en, this message translates to:
  /// **'Sign in via Browser'**
  String get signInViaBrowser;

  /// Shown when secure tokens for the account cannot be found in secure storage. This may happen in portable mode or when switching to a different OS user, desktop environment (e.g. Gnome/KDE), or operating system.
  ///
  /// In en, this message translates to:
  /// **'Secure account data is missing. This can happen if you\'re using a different system user, desktop environment, or operating system. Please sign in again to continue.'**
  String get reAuthRequiredDueToMissingSecureAccountDataDetailed;

  /// Shown when secure account tokens cannot be found in secure storage, which is only used when secure storage is enabled. Appears when the user attempts an action that requires Microsoft re-authentication.
  ///
  /// In en, this message translates to:
  /// **'Secure account data is missing. Please sign in again to continue.'**
  String get reAuthRequiredDueToMissingSecureAccountData;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// Shown when account tokens cannot be found in file storage, which is only used when secure storage is disabled. Appears when the user attempts an action that requires Microsoft re-authentication.
  ///
  /// In en, this message translates to:
  /// **'Account tokens are missing. Please sign in again to continue.'**
  String get reAuthRequiredDueToMissingAccountTokensFromFileStorage;

  /// No description provided for @securityWarning.
  ///
  /// In en, this message translates to:
  /// **'Security Warning'**
  String get securityWarning;

  /// Displayed when the user's operating system does not support secure storage. Account tokens will be saved unencrypted in a local file, increasing the risk of unauthorized access. Users should be cautious with installed programs and mods.
  ///
  /// In en, this message translates to:
  /// **'Secure storage is not supported on this platform. Account tokens will be stored unencrypted in a local file. Be cautious with installed programs and Minecraft mods.'**
  String get secureStorageUnsupportedWarning;

  /// No description provided for @updateMicrosoftAccount.
  ///
  /// In en, this message translates to:
  /// **'Update Microsoft Account'**
  String get updateMicrosoftAccount;

  /// Shown when a request to api.minecraftservices.com fails with a 503 Service Unavailable response. Indicates that Minecraft services are temporarily unavailable during communication with the API, such as login or other account-related operations.
  ///
  /// In en, this message translates to:
  /// **'Minecraft services are currently unavailable. Please try again in a few minutes.'**
  String get minecraftServicesApiUnavailable;

  /// Shown when the local HTTP server used to receive Microsoft's redirect during auth code login cannot start because the selected port is already in use. This prevents the app from receiving the login response from Microsoft.
  ///
  /// In en, this message translates to:
  /// **'Unable to start the local server required for login. Port {port} is already in use.'**
  String authCodeServerStartFailurePortInUse(int port);

  /// Shown when the local HTTP server used to receive Microsoft's redirect cannot start because the operating system denied permission. This can be caused by firewall rules, antivirus software, admin restrictions, or security policies.
  ///
  /// In en, this message translates to:
  /// **'Unable to start the local server required for login due to system restrictions.'**
  String get authCodeServerStartFailurePermissionDenied;

  /// Shown when the local HTTP server, used to receive Microsoft's redirect after sign-in, fails to start due to an unknown or unclassified error.
  ///
  /// In en, this message translates to:
  /// **'Unable to start the local server required for login due to an unexpected error.'**
  String get authCodeServerStartFailureUnexpected;

  /// Shown to the user when the app cannot reach the internet or server due to network issues.
  ///
  /// In en, this message translates to:
  /// **'Connection failed. Please check your internet connection and try again.'**
  String get connectionFailure;

  /// Label for a button shown when an unclear error occurs (e.g., connection failures) and the technical details are not user-friendly. Tapping this button opens a dialog displaying the full technical error details.
  ///
  /// In en, this message translates to:
  /// **'Show details'**
  String get showErrorDetailsButton;

  /// Title of the dialog that shows detailed technical information about an expected error for debugging or reporting purposes
  ///
  /// In en, this message translates to:
  /// **'Technical details'**
  String get technicalErrorDetailsDialogTitle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'de', 'en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
