import 'package:kraft_launcher/account/data/microsoft_auth_api/microsoft_auth_api.dart';
import 'package:kraft_launcher/account/data/microsoft_auth_api/microsoft_auth_api_exceptions.dart'
    as microsoft_auth_api_exceptions;
import 'package:kraft_launcher/account/logic/launcher_minecraft_account/account_repository.dart';
import 'package:kraft_launcher/account/logic/launcher_minecraft_account/minecraft_account.dart';
import 'package:kraft_launcher/account/logic/microsoft/auth_flows/auth_code/microsoft_auth_code_flow.dart';
import 'package:kraft_launcher/account/logic/microsoft/auth_flows/auth_code/microsoft_auth_code_flow_exceptions.dart'
    as microsoft_auth_code_flow_exceptions;
import 'package:kraft_launcher/account/logic/microsoft/auth_flows/device_code/microsoft_device_code_flow.dart';
import 'package:kraft_launcher/account/logic/microsoft/auth_flows/microsoft_oauth_flow_controller.dart';
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_refresher/minecraft_account_refresher.dart';
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_refresher/minecraft_account_refresher_exceptions.dart'
    as minecraft_account_refresher_exceptions;
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_resolver/minecraft_account_resolver.dart';
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_resolver/minecraft_account_resolver_exceptions.dart'
    as minecraft_account_resolver_exceptions;
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_service/minecraft_account_service_exceptions.dart'
    as minecraft_account_service_exceptions;
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_service/minecraft_auth_progress.dart';
import 'package:meta/meta.dart';

/// A service for logging into and managing Minecraft accounts via Microsoft.
///
/// Handles Microsoft OAuth login (auth code and device code), refreshes tokens,
/// resolves Minecraft accounts, and persists them via [AccountRepository].
///
/// All operations are specific to **Microsoft-backed Minecraft accounts**.
class MinecraftAccountService {
  MinecraftAccountService({
    required AccountRepository accountRepository,
    required MicrosoftOAuthFlowController microsoftOAuthFlowController,
    required MinecraftAccountResolver minecraftAccountResolver,
    required MinecraftAccountRefresher minecraftAccountRefresher,
  }) : _accountRepository = accountRepository,
       _microsoftOAuthFlowController = microsoftOAuthFlowController,
       _minecraftAccountResolver = minecraftAccountResolver,
       _minecraftAccountRefresher = minecraftAccountRefresher;

  final AccountRepository _accountRepository;
  final MicrosoftOAuthFlowController _microsoftOAuthFlowController;
  final MinecraftAccountResolver _minecraftAccountResolver;
  final MinecraftAccountRefresher _minecraftAccountRefresher;

  Future<T> _transformExceptions<T>(
    Future<T> Function() run, {
    Future<void> Function(
      microsoft_auth_api_exceptions.MicrosoftAuthApiException e,
    )?
    onMicrosoftAuthApiException,
  }) async {
    // TODO: Avoid using exceptions for expected failures. Use the Result pattern.
    //  URL: https://github.com/KraftLauncher/kraft-launcher/issues/8
    try {
      return await run();
    } on microsoft_auth_api_exceptions.MicrosoftAuthApiException catch (e) {
      throw minecraft_account_service_exceptions.MicrosoftAuthApiException(e);
    } on minecraft_account_api_exceptions.MinecraftAccountApiException catch (
      e
    ) {
      throw minecraft_account_service_exceptions.MinecraftAccountApiException(
        e,
      );
    } on microsoft_auth_code_flow_exceptions.MicrosoftAuthCodeFlowException catch (
      e
    ) {
      throw minecraft_account_service_exceptions.MicrosoftAuthCodeFlowException(
        e,
      );
    } on minecraft_account_resolver_exceptions.MinecraftAccountResolverException catch (
      e
    ) {
      throw minecraft_account_service_exceptions.MinecraftAccountResolverException(
        e,
      );
    } on minecraft_account_refresher_exceptions.MinecraftAccountRefresherException catch (
      e
    ) {
      throw minecraft_account_service_exceptions.MinecraftAccountRefresherException(
        e,
      );
    }
  }

  Future<MinecraftLoginResult?> loginWithMicrosoftAuthCode({
    required MinecraftAuthProgressCallback onProgress,
    required AuthCodeLoginUrlAvailableCallback onAuthCodeLoginUrlAvailable,
    // The page content is not hardcoded for localization.
    required MicrosoftAuthCodeResponsePageVariants authCodeResponsePageVariants,
  }) async => _transformExceptions(() async {
    final tokenResponse = await _microsoftOAuthFlowController
        .loginWithMicrosoftAuthCode(
          onProgress: (progress) => onProgress(switch (progress) {
            MicrosoftAuthCodeProgress.waitingForUserLogin =>
              MinecraftAuthProgress.waitingForUserLogin,
            MicrosoftAuthCodeProgress.exchangingAuthCode =>
              MinecraftAuthProgress.exchangingAuthCode,
          }),
          onAuthCodeLoginUrlAvailable: onAuthCodeLoginUrlAvailable,
          authCodeResponsePageVariants: authCodeResponsePageVariants,
        );
    if (tokenResponse == null) {
      return null;
    }

    return _resolveAndSave(
      tokenResponse: tokenResponse,
      onProgress: onProgress,
    );
  });

  Future<MinecraftDeviceCodeLoginResult> requestLoginWithMicrosoftDeviceCode({
    required MinecraftAuthProgressCallback onProgress,
    required UserDeviceCodeAvailableCallback onUserDeviceCodeAvailable,
  }) => _transformExceptions(() async {
    final (tokenResponse, closeReason) = await _microsoftOAuthFlowController
        .requestLoginWithMicrosoftDeviceCode(
          onProgress: (progress) => onProgress(switch (progress) {
            MicrosoftDeviceCodeProgress.waitingForUserLogin =>
              MinecraftAuthProgress.waitingForUserLogin,
          }),
          onUserDeviceCodeAvailable: onUserDeviceCodeAvailable,
        );
    if (tokenResponse == null) {
      return MinecraftDeviceCodeLoginResult(
        loginResult: null,
        closeReason: closeReason,
      );
    }

    final loginResult = await _resolveAndSave(
      tokenResponse: tokenResponse,
      onProgress: onProgress,
    );

    return MinecraftDeviceCodeLoginResult(
      loginResult: loginResult,
      closeReason: closeReason,
    );
  });

  Future<MinecraftLoginResult> _resolveAndSave({
    required MicrosoftOAuthTokenResponse tokenResponse,
    required MinecraftAuthProgressCallback onProgress,
  }) async {
    final account = await _minecraftAccountResolver.resolve(
      oauthTokenResponse: tokenResponse,
      onProgress: (progress) => onProgress(_resolveToAuthProgress(progress)),
    );
    final accountExists = _accountRepository.accountExists(account.id);
    if (accountExists) {
      await _accountRepository.updateAccount(account);
    } else {
      await _accountRepository.addAccount(account);
    }

    return MinecraftLoginResult(account: account, accountExists: accountExists);
  }

  // TODO: MinecraftAccountRefresher probably should not delegate to MinecraftAccountResolver directly??
  //  Also refreshMinecraftAccessTokenIfExpired should not depend on
  //  MicrosoftAuthApi and MinecraftAccountApi directly? Since thoes are also dependencies of MinecraftAccountResolver.
  MinecraftAuthProgress _resolveToAuthProgress(
    ResolveMinecraftAccountProgress progress,
  ) => switch (progress) {
    ResolveMinecraftAccountProgress.requestingXboxToken =>
      MinecraftAuthProgress.requestingXboxToken,
    ResolveMinecraftAccountProgress.requestingXstsToken =>
      MinecraftAuthProgress.requestingXstsToken,
    ResolveMinecraftAccountProgress.loggingIntoMinecraft =>
      MinecraftAuthProgress.loggingIntoMinecraft,
    ResolveMinecraftAccountProgress.checkingMinecraftJavaOwnership =>
      MinecraftAuthProgress.checkingMinecraftJavaOwnership,
    ResolveMinecraftAccountProgress.fetchingProfile =>
      MinecraftAuthProgress.fetchingProfile,
  };

  Future<bool> closeAuthCodeServer() =>
      _microsoftOAuthFlowController.closeAuthCodeServer();

  bool cancelDeviceCodePollingTimer() =>
      _microsoftOAuthFlowController.cancelDeviceCodePollingTimer();

  Future<MinecraftAccount> refreshMicrosoftAccount(
    MinecraftAccount account, {
    required MinecraftAuthProgressCallback onProgress,
  }) async => _transformExceptions(() async {
    try {
      final refreshedAccount = await _minecraftAccountRefresher
          .refreshMicrosoftAccount(
            account,
            onRefreshProgress: (progress) => onProgress(switch (progress) {
              RefreshMinecraftAccountProgress.refreshingMicrosoftTokens =>
                MinecraftAuthProgress.refreshingMicrosoftTokens,
            }),
            onResolveAccountProgress: (progress) =>
                onProgress(_resolveToAuthProgress(progress)),
          );

      await _accountRepository.updateAccount(refreshedAccount);

      return refreshedAccount;
    } on minecraft_account_refresher_exceptions.InvalidMicrosoftRefreshTokenException catch (
      e
    ) {
      await _accountRepository.updateAccount(e.updatedAccount);
      rethrow;
    }
  });
}

@immutable
class MinecraftLoginResult {
  const MinecraftLoginResult({
    required this.account,
    required this.accountExists,
  });

  final MinecraftAccount account;
  final bool accountExists;
}

@immutable
class MinecraftDeviceCodeLoginResult {
  const MinecraftDeviceCodeLoginResult({
    required this.loginResult,
    required this.closeReason,
  });

  final MinecraftLoginResult? loginResult;
  final DeviceCodeTimerCloseReason closeReason;
}

typedef MinecraftAuthProgressCallback =
    void Function(MinecraftAuthProgress progress);
