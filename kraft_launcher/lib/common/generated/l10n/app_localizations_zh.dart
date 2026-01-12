// dart format off
// coverage:ignore-file

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get settings => '设置';

  @override
  String get home => '首页';

  @override
  String get profiles => '配置文件';

  @override
  String get accounts => '账户';

  @override
  String get about => '关于';

  @override
  String get switchAccount => '切换账户';

  @override
  String get play => '开始游戏';

  @override
  String get addAccount => '添加账户';

  @override
  String get cancel => '取消';

  @override
  String get microsoft => 'Microsoft';

  @override
  String get offline => '离线';

  @override
  String get signInWithMicrosoft => '使用 Microsoft 登录';

  @override
  String get addMicrosoftAccount => '添加 Microsoft 账户';

  @override
  String get copyCode => '复制代码';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get deviceCodeStepVisit => '1. 访问';

  @override
  String get deviceCodeStepEnter => '2. 输入以下代码：';

  @override
  String get deviceCodeQrInstruction => '扫描以在其他设备上打开链接。\n你仍然需要输入上面的代码。';

  @override
  String get loggingInWithMicrosoftAccount => '正在使用 Microsoft 账户登录';

  @override
  String get authProgressWaitingForUserLogin => '正在等待用户验证...';

  @override
  String get authProgressExchangingAuthCode => '正在交换授权码...';

  @override
  String get authProgressRequestingXboxLiveToken => '正在请求 Xbox Live 访问权限...';

  @override
  String get authProgressRequestingXstsToken => '正在授权 Xbox Live 会话...';

  @override
  String get authProgressLoggingIntoMinecraft => '正在登录 Minecraft 服务...';

  @override
  String get authProgressFetchingMinecraftProfile => '正在获取 Minecraft 个人资料...';

  @override
  String loginSuccessAccountAddedMessage(String username) {
    return '欢迎，$username！你已成功登录 Minecraft。';
  }

  @override
  String loginSuccessAccountUpdatedMessage(String username) {
    return '欢迎回来，$username！你的账户信息已更新。';
  }

  @override
  String get username => '用户名';

  @override
  String get accountType => '账户类型';

  @override
  String get removeAccount => '移除账户';

  @override
  String unexpectedError(String message) {
    return '意外错误：$message。';
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
  String get missingAuthCodeError => '未提供授权码。请重新开始登录。';

  @override
  String get expiredAuthCodeError => '授权码已过期。请重新开始登录流程。';

  @override
  String get expiredMicrosoftAccessTokenError => 'Microsoft OAuth 访问令牌已过期。需要重新登录。';

  @override
  String get unauthorizedMinecraftAccessError => '未授权访问 Minecraft。授权已过期或无效。';

  @override
  String get createOfflineAccount => '创建离线账户';

  @override
  String get updateOfflineAccount => '更新离线账户';

  @override
  String get offlineMinecraftAccountCreationNotice => '请输入你想要的 Minecraft 用户名。离线账户将被保存在本地，无法访问在线服务器或 Realms。';

  @override
  String get create => '创建';

  @override
  String get minecraftUsernameHint => '例如：Steve';

  @override
  String get usernameEmptyError => '用户名不能为空';

  @override
  String get usernameTooShortError => '用户名至少需要 3 个字符';

  @override
  String get usernameTooLongError => '用户名最多只能包含 16 个字符';

  @override
  String get usernameInvalidCharactersError => '用户名只能包含字母、数字和下划线。';

  @override
  String get usernameContainsWhitespacesError => '用户名不能包含空格。';

  @override
  String get update => '更新';

  @override
  String get minecraftId => 'Minecraft ID';

  @override
  String get removeAccountConfirmation => '确认移除账户？';

  @override
  String get removeAccountConfirmationNotice => '该账户将从启动器中移除。\n你需要重新添加才能使用该账户进行游戏。';

  @override
  String get remove => '移除';

  @override
  String get chooseYourPreferredLanguage => '选择你偏好的语言';

  @override
  String get appLanguage => '应用语言';

  @override
  String get system => '系统';

  @override
  String get themeMode => '主题模式';

  @override
  String get selectDarkLightOrSystemTheme => '选择深色、浅色或系统主题';

  @override
  String get classicMaterialDesign => '经典 Material Design';

  @override
  String get useClassicMaterialDesignTheme => '使用经典 Material Design 主题';

  @override
  String get dynamicColor => '动态配色';

  @override
  String get automaticallyAdaptToSystemColors => '自动适应系统配色';

  @override
  String get general => '通用';

  @override
  String get java => 'Java';

  @override
  String get launcher => '启动器';

  @override
  String get advanced => '高级';

  @override
  String get appearance => '外观';

  @override
  String get dark => '深色';

  @override
  String get light => '浅色';

  @override
  String get customAccentColor => '自定义强调色';

  @override
  String get customizeAccentColor => '自定义应用主题的强调色。';

  @override
  String get pickAColor => '选择颜色';

  @override
  String get close => '关闭';

  @override
  String get or => '或';

  @override
  String get loginDeviceCodeExpired => '登录代码已过期。请再试一次。';

  @override
  String get tryAgain => '请再试一次';

  @override
  String get uiPreferences => '界面偏好设置';

  @override
  String get defaultTab => '默认标签页';

  @override
  String get initialTabSelectionDescription => '选择应用启动时首先显示的标签页';

  @override
  String get search => '搜索';

  @override
  String get refreshAccount => '刷新账户';

  @override
  String get sessionExpiredOrAccessRevoked => '账户会话已过期或访问权限已被撤销。请重新登录以继续。';

  @override
  String accountRefreshedMessage(String username) {
    return '$username 的账户已成功刷新。';
  }

  @override
  String get revokeAccess => '撤销访问';

  @override
  String get microsoftRequestLimitError => '与 Microsoft 认证服务器通信时达到请求限制。请稍后再试。';

  @override
  String get authProgressRefreshingMicrosoftTokens => '正在刷新 Microsoft 令牌...';

  @override
  String get authProgressCheckingMinecraftJavaOwnership => '正在检查 Minecraft Java 所有权...';

  @override
  String get waitForOngoingTask => '请稍等，当前任务正在完成。';

  @override
  String get accountsEmptyTitle => '管理 Minecraft 账户';

  @override
  String get accountsEmptySubtitle => '添加 Minecraft 账户以实现无缝切换。账户安全存储在此设备上。';

  @override
  String get authCodeRedirectPageLoginSuccessTitle => '登录成功';

  @override
  String authCodeRedirectPageLoginSuccessMessage(String launcherName) {
    return '您已成功使用 Microsoft 账户登录到 $launcherName。您现在可以关闭此窗口。';
  }

  @override
  String get errorOccurred => '发生了一个错误';

  @override
  String get reportBug => '报告错误';

  @override
  String get unknownErrorWhileLoadingAccounts => '加载账户时发生了未知错误。请稍后再试。';

  @override
  String get minecraftRequestLimitError => '与Minecraft服务器通信时达到请求限制。请稍后再试。';

  @override
  String unexpectedMicrosoftApiError(Object message) {
    return '与Microsoft服务器通信时发生意外错误：$message。请稍后再试。';
  }

  @override
  String errorLoadingNetworkImage(Object message) {
    return '加载图像时发生错误：$message';
  }

  @override
  String get skinModelClassic => '经典';

  @override
  String get skinModelSlim => '瘦身';

  @override
  String get skinModel => '皮肤模型';

  @override
  String get updateSkin => '更新皮肤';

  @override
  String get featureUnsupportedYet => '此功能尚不支持。请关注未来的更新！';

  @override
  String get news => '新闻';

  @override
  String legalDisclaimerMessage(String launcherName) {
    return '$launcherName 不是官方的Minecraft产品。未获得Mojang或Microsoft的批准或与其关联。';
  }

  @override
  String get support => '支持';

  @override
  String get website => '网站';

  @override
  String get contact => '联系方式';

  @override
  String get askQuestion => '提问';

  @override
  String get license => '许可证';

  @override
  String get sourceCode => '源代码';

  @override
  String get invalidMinecraftSkinFile => '无效的皮肤图像。请上传有效的Minecraft皮肤文件。';

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
