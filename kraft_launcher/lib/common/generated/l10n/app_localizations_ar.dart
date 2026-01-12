// dart format off
// coverage:ignore-file

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get settings => 'الإعدادات';

  @override
  String get home => 'الرئيسية';

  @override
  String get profiles => 'الملفات الشخصية';

  @override
  String get accounts => 'الحسابات';

  @override
  String get about => 'حول';

  @override
  String get switchAccount => 'تبديل الحساب';

  @override
  String get play => 'تشغيل';

  @override
  String get addAccount => 'إضافة حساب';

  @override
  String get cancel => 'إلغاء';

  @override
  String get microsoft => 'مايكروسوفت';

  @override
  String get offline => 'بدون اتصال';

  @override
  String get signInWithMicrosoft => 'تسجيل الدخول باستخدام مايكروسوفت';

  @override
  String get addMicrosoftAccount => 'إضافة حساب مايكروسوفت';

  @override
  String get copyCode => 'نسخ الرمز';

  @override
  String get copiedToClipboard => 'تم النسخ إلى الحافظة';

  @override
  String get deviceCodeStepVisit => '1. قم بزيارة';

  @override
  String get deviceCodeStepEnter => '2. أدخل الرمز أدناه:';

  @override
  String get deviceCodeQrInstruction => 'امسح لفتح الرابط على جهاز آخر.\nستحتاج إلى إدخال الرمز أعلاه أيضاً.';

  @override
  String get loggingInWithMicrosoftAccount => 'جاري تسجيل الدخول بحساب مايكروسوفت';

  @override
  String get authProgressWaitingForUserLogin => 'بانتظار مصادقة المستخدم...';

  @override
  String get authProgressExchangingAuthCode => 'جارٍ استبدال رمز التفويض...';

  @override
  String get authProgressRequestingXboxLiveToken => 'طلب الوصول إلى Xbox Live...';

  @override
  String get authProgressRequestingXstsToken => 'تفويض جلسة Xbox Live...';

  @override
  String get authProgressLoggingIntoMinecraft => 'تسجيل الدخول إلى خدمات Minecraft...';

  @override
  String get authProgressFetchingMinecraftProfile => 'جلب ملف Minecraft الشخصي...';

  @override
  String loginSuccessAccountAddedMessage(String username) {
    return 'مرحباً، $username! لقد سجلت الدخول إلى Minecraft بنجاح.';
  }

  @override
  String loginSuccessAccountUpdatedMessage(String username) {
    return 'مرحباً مجدداً، $username! تم تحديث تفاصيل حسابك.';
  }

  @override
  String get username => 'اسم المستخدم';

  @override
  String get accountType => 'نوع الحساب';

  @override
  String get removeAccount => 'إزالة الحساب';

  @override
  String unexpectedError(String message) {
    return 'خطأ غير متوقع: $message.';
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
  String get missingAuthCodeError => 'لم يتم توفير رمز التفويض. يجب إعادة بدء تسجيل الدخول.';

  @override
  String get expiredAuthCodeError => 'انتهت صلاحية رمز التفويض. يرجى إعادة بدء عملية تسجيل الدخول.';

  @override
  String get expiredMicrosoftAccessTokenError => 'انتهت صلاحية رمز وصول OAuth لمايكروسوفت. يجب تسجيل الدخول من جديد.';

  @override
  String get unauthorizedMinecraftAccessError => 'وصول غير مصرح به إلى Minecraft. انتهت صلاحية التفويض أو أنه غير صالح.';

  @override
  String get createOfflineAccount => 'إنشاء حساب بدون اتصال';

  @override
  String get updateOfflineAccount => 'تحديث حساب بدون اتصال';

  @override
  String get offlineMinecraftAccountCreationNotice => 'أدخل اسم مستخدم Minecraft الذي ترغب به. يتم تخزين الحسابات غير المتصلة محليًا ولا يمكنها الوصول إلى الخوادم أو العوالم عبر الإنترنت.';

  @override
  String get create => 'إنشاء';

  @override
  String get minecraftUsernameHint => 'مثال: Steve';

  @override
  String get usernameEmptyError => 'لا يمكن أن يكون اسم المستخدم فارغًا';

  @override
  String get usernameTooShortError => 'يجب أن يحتوي اسم المستخدم على 3 أحرف على الأقل';

  @override
  String get usernameTooLongError => 'يجب ألا يتجاوز اسم المستخدم 16 حرفًا';

  @override
  String get usernameInvalidCharactersError => 'يمكن أن يحتوي اسم المستخدم على أحرف وأرقام وعلامات underscore (_) فقط.';

  @override
  String get usernameContainsWhitespacesError => 'لا يمكن أن يحتوي اسم المستخدم على مسافات.';

  @override
  String get update => 'تحديث';

  @override
  String get minecraftId => 'معرّف Minecraft';

  @override
  String get removeAccountConfirmation => 'هل تريد إزالة الحساب؟';

  @override
  String get removeAccountConfirmationNotice => 'سيتم إزالة هذا الحساب من المشغل.\nستحتاج إلى إضافته مرة أخرى لاستخدامه في اللعب.';

  @override
  String get remove => 'إزالة';

  @override
  String get chooseYourPreferredLanguage => 'اختر لغتك المفضلة';

  @override
  String get appLanguage => 'لغة التطبيق';

  @override
  String get system => 'النظام';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get selectDarkLightOrSystemTheme => 'اختر بين الوضع الداكن أو الفاتح أو نظام الجهاز';

  @override
  String get classicMaterialDesign => 'تصميم Material الكلاسيكي';

  @override
  String get useClassicMaterialDesignTheme => 'استخدم تصميم Material الكلاسيكي';

  @override
  String get dynamicColor => 'ألوان ديناميكية';

  @override
  String get automaticallyAdaptToSystemColors => 'التكيّف التلقائي مع ألوان النظام';

  @override
  String get general => 'عام';

  @override
  String get java => 'جافا';

  @override
  String get launcher => 'المشغل';

  @override
  String get advanced => 'متقدم';

  @override
  String get appearance => 'المظهر';

  @override
  String get dark => 'داكن';

  @override
  String get light => 'فاتح';

  @override
  String get customAccentColor => 'لون التمييز المخصص';

  @override
  String get customizeAccentColor => 'قم بتخصيص لون التمييز لمظهر التطبيق.';

  @override
  String get pickAColor => 'اختر لونًا';

  @override
  String get close => 'إغلاق';

  @override
  String get or => 'أو';

  @override
  String get loginDeviceCodeExpired => 'رمز الدخول قد انتهت صلاحيته. يرجى المحاولة مرة أخرى.';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get uiPreferences => 'تفضيلات الواجهة';

  @override
  String get defaultTab => 'علامة التبويب الافتراضية';

  @override
  String get initialTabSelectionDescription => 'اختر علامة التبويب التي تظهر أولاً عند فتح التطبيق';

  @override
  String get search => 'بحث';

  @override
  String get refreshAccount => 'تحديث الحساب';

  @override
  String get sessionExpiredOrAccessRevoked => 'انتهت جلسة الحساب أو تم إلغاء الوصول. يرجى تسجيل الدخول مرة أخرى للاستمرار.';

  @override
  String accountRefreshedMessage(String username) {
    return 'تم تحديث الحساب لـ $username بنجاح.';
  }

  @override
  String get revokeAccess => 'إلغاء الوصول';

  @override
  String get microsoftRequestLimitError => 'تم الوصول إلى حد الطلبات أثناء الاتصال بخوادم مصادقة Microsoft. يرجى المحاولة مرة أخرى بعد قليل.';

  @override
  String get authProgressRefreshingMicrosoftTokens => 'جارٍ تحديث رموز Microsoft...';

  @override
  String get authProgressCheckingMinecraftJavaOwnership => 'جارٍ التحقق من ملكية Minecraft Java...';

  @override
  String get waitForOngoingTask => 'يرجى الانتظار حتى ينتهي المهمة الحالية.';

  @override
  String get accountsEmptyTitle => 'إدارة حسابات Minecraft';

  @override
  String get accountsEmptySubtitle => 'أضف حسابات Minecraft للتبديل السلس. يتم تخزين الحسابات بأمان على هذا الجهاز.';

  @override
  String get authCodeRedirectPageLoginSuccessTitle => 'تم تسجيل الدخول';

  @override
  String authCodeRedirectPageLoginSuccessMessage(String launcherName) {
    return 'لقد قمت بتسجيل الدخول بنجاح إلى $launcherName باستخدام حساب Microsoft الخاص بك. يمكنك الآن إغلاق هذه النافذة.';
  }

  @override
  String get errorOccurred => 'حدث خطأ';

  @override
  String get reportBug => 'الإبلاغ عن خطأ';

  @override
  String get unknownErrorWhileLoadingAccounts => 'حدث خطأ غير معروف أثناء تحميل الحسابات. يرجى المحاولة لاحقًا.';

  @override
  String get minecraftRequestLimitError => 'تم الوصول إلى حد الطلب أثناء التواصل مع خوادم ماينكرافت. يرجى المحاولة لاحقًا.';

  @override
  String unexpectedMicrosoftApiError(Object message) {
    return 'حدث خطأ غير متوقع أثناء التواصل مع خوادم مايكروسوفت: $message. يرجى المحاولة لاحقًا.';
  }

  @override
  String errorLoadingNetworkImage(Object message) {
    return 'حدث خطأ أثناء تحميل الصورة: $message';
  }

  @override
  String get skinModelClassic => 'كلاسيكي';

  @override
  String get skinModelSlim => 'نحيف';

  @override
  String get skinModel => 'نموذج الجلد';

  @override
  String get updateSkin => 'تحديث الجلد';

  @override
  String get featureUnsupportedYet => 'هذه الميزة غير مدعومة بعد. تابع التحديثات المستقبلية!';

  @override
  String get news => 'أخبار';

  @override
  String legalDisclaimerMessage(String launcherName) {
    return '$launcherName ليس منتج Minecraft رسمي. لم يتم اعتماده أو ربطه مع Mojang أو Microsoft.';
  }

  @override
  String get support => 'الدعم';

  @override
  String get website => 'الموقع الإلكتروني';

  @override
  String get contact => 'اتصل';

  @override
  String get askQuestion => 'اطرح سؤالاً';

  @override
  String get license => 'رخصة';

  @override
  String get sourceCode => 'رمز المصدر';

  @override
  String get invalidMinecraftSkinFile => 'صورة سكين غير صالحة. يرجى تحميل ملف سكين Minecraft صالح.';

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
