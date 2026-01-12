import 'package:kraft_launcher/account/data/image_cache_service/image_cache_service.dart';
import 'package:kraft_launcher/account/data/microsoft_auth_api/microsoft_auth_api.dart';
import 'package:kraft_launcher/account/data/microsoft_auth_api/microsoft_auth_api_exceptions.dart'
    as microsoft_auth_api_exceptions;
import 'package:kraft_launcher/account/logic/launcher_minecraft_account/minecraft_account.dart';
import 'package:kraft_launcher/account/logic/microsoft/microsoft_refresh_token_expiration.dart';
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_refresher/minecraft_account_refresher_exceptions.dart'
    as refresher;
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_resolver/minecraft_account_resolver.dart';
import 'package:kraft_launcher/account/logic/minecraft_skin_ext.dart';
import 'package:kraft_launcher/common/logic/utils.dart';
import 'package:meta/meta.dart';
import 'package:minecraft_services_repository/minecraft_services_repository.dart';
import 'package:result/result.dart';

/// Handles the token refresh flow for Microsoft-based Minecraft
/// accounts authenticated via Microsoft OAuth.
///
/// Runs regardless of the Microsoft authentication flow used
/// (device code or auth code).
///
/// Stateless and pure; does not cache or persist any data.
class MinecraftAccountRefresher {
  MinecraftAccountRefresher({
    required ImageCacheService imageCacheService,
    required MicrosoftAuthApi microsoftAuthApi,
    required MinecraftServicesRepository minecraftServicesRepository,
    required MinecraftAccountResolver accountResolver,
  }) : _imageCacheService = imageCacheService,
       _microsoftAuthApi = microsoftAuthApi,
       _accountResolver = accountResolver,
       _minecraftServicesRepository = minecraftServicesRepository;

  final ImageCacheService _imageCacheService;
  final MicrosoftAuthApi _microsoftAuthApi;
  final MinecraftServicesRepository _minecraftServicesRepository;
  final MinecraftAccountResolver _accountResolver;

  Future<MinecraftAccount> refreshMicrosoftAccount(
    MinecraftAccount account, {
    required RefreshMinecraftAccountProgressCallback onRefreshProgress,
    required ResolveMinecraftAccountProgressCallback onResolveAccountProgress,
  }) async {
    assert(
      account.accountType == AccountType.microsoft,
      'Expected the account type to be Microsoft, but received: ${account.accountType.name}',
    );

    final microsoftAccountInfo = account.microsoftAccountInfo;
    if (microsoftAccountInfo == null) {
      throw ArgumentError.value(
        account,
        'account',
        'The $MicrosoftAccountInfo must not be null when refreshing'
            ' the Microsoft account. Account Type: ${account.accountType.name}',
      );
    }

    _throwsIfNeedsMicrosoftReAuth(account);

    final microsoftRefreshToken =
        microsoftAccountInfo.microsoftRefreshToken.value ??
        (throw StateError(
          'Microsoft refresh token should not be null to refresh the account',
        ));

    try {
      onRefreshProgress(
        RefreshMinecraftAccountProgress.refreshingMicrosoftTokens,
      );
      final oauthTokenResponse = await _microsoftAuthApi
          .getNewTokensFromRefreshToken(microsoftRefreshToken);

      // Delete current cached skin images.
      await _imageCacheService.evictFromCache(account.headSkinImageUrl);
      await _imageCacheService.evictFromCache(account.fullSkinImageUrl);

      return await _accountResolver.resolve(
        oauthTokenResponse: oauthTokenResponse,
        onProgress: onResolveAccountProgress,
      );
    } on microsoft_auth_api_exceptions.InvalidRefreshTokenException {
      final updatedAccount = account.copyWith(
        microsoftAccountInfo: microsoftAccountInfo.copyWith(
          reauthRequiredReason: MicrosoftReauthRequiredReason.accessRevoked,
        ),
      );
      throw refresher.InvalidMicrosoftRefreshTokenException(updatedAccount);
    }
  }

  // Refreshes a Microsoft account if the Minecraft access token is expired.
  // TODO: More consideration is needed, test it with skin update feature first.
  //  Manually test handling of Microsoft refresh token expiration
  @experimental
  Future<MinecraftAccount> refreshMinecraftAccessTokenIfExpired(
    MinecraftAccount account, {
    required RefreshMinecraftAccessTokenProgressCallback onRefreshProgress,
  }) async {
    final microsoftAccountInfo = account.microsoftAccountInfo;
    if (microsoftAccountInfo == null) {
      throw ArgumentError.value(
        account,
        'account',
        'The $MicrosoftAccountInfo must not be null when validating the '
            'Minecraft access token. Account Type: ${account.accountType.name}',
      );
    }
    final hasExpired =
        microsoftAccountInfo.minecraftAccessToken.expiresAt.hasExpired;
    if (hasExpired) {
      _throwsIfNeedsMicrosoftReAuth(account);

      final microsoftRefreshToken =
          microsoftAccountInfo.microsoftRefreshToken.value ??
          (throw StateError(
            'Microsoft refresh token should not be null to refresh the Minecraft access token',
          ));

      onRefreshProgress(
        RefreshMinecraftAccessTokenProgress.refreshingMicrosoftTokens,
      );
      final microsoftRefreshResponse = await _microsoftAuthApi
          .getNewTokensFromRefreshToken(microsoftRefreshToken);

      // TODO: Part of MinecraftAccountResolver logic (Xbox → XSTS → Login)
      //  is duplicated in here just to avoid the full profile resolution.
      //  We may need to refactor some of the code for a better solution.

      onRefreshProgress(
        RefreshMinecraftAccessTokenProgress.requestingXboxToken,
      );
      final xboxResponse = await _microsoftAuthApi.requestXboxLiveToken(
        microsoftRefreshResponse.accessToken,
      );

      onRefreshProgress(
        RefreshMinecraftAccessTokenProgress.requestingXstsToken,
      );
      final xstsTokenResponse = await _microsoftAuthApi.requestXSTSToken(
        xboxResponse.xboxToken,
      );

      onRefreshProgress(
        RefreshMinecraftAccessTokenProgress.loggingIntoMinecraft,
      );
      final xboxAuthResult = await _minecraftServicesRepository
          .authenticateWithXbox(
            xstsAccessToken: xstsTokenResponse.xboxToken,
            xstsUserHash: xstsTokenResponse.userHash,
          );
      final minecraftLoginResponse = switch (xboxAuthResult) {
        SuccessResult(:final value) => value,
        FailureResult(:final failure) =>
          // Throw an exception for backward compatibility reasons.
          // See WrappedMinecraftServicesException for more info.
          throw refresher.WrappedMinecraftServicesException(failure),
      };

      final refreshedAccount = account.copyWith(
        microsoftAccountInfo: microsoftAccountInfo.copyWith(
          minecraftAccessToken: ExpirableToken(
            value: minecraftLoginResponse.accessToken,
            expiresAt: expiresInToExpiresAt(minecraftLoginResponse.expiresIn),
          ),
          microsoftRefreshToken: ExpirableToken(
            value: microsoftRefreshResponse.refreshToken,
            expiresAt: microsoftRefreshTokenExpiresAt(),
          ),
        ),
      );

      return refreshedAccount;
    }
    return account;
  }

  void _throwsIfNeedsMicrosoftReAuth(MinecraftAccount account) {
    final reAuthRequiredReason =
        account.microsoftAccountInfo?.reauthRequiredReason;
    if (reAuthRequiredReason != null) {
      throw refresher.MicrosoftReAuthRequiredException(reAuthRequiredReason);
    }
    // NOTE: Microsoft refresh token expiration (after 90 days) is checked when loading accounts.
    // In rare cases, a token might expire shortly after loading but before use.
    // We accept this edge case to keep the logic simple.
  }
}

enum RefreshMinecraftAccountProgress { refreshingMicrosoftTokens }

typedef RefreshMinecraftAccountProgressCallback =
    void Function(RefreshMinecraftAccountProgress progress);

typedef RefreshMinecraftAccessTokenProgressCallback =
    void Function(RefreshMinecraftAccessTokenProgress progress);

enum RefreshMinecraftAccessTokenProgress {
  refreshingMicrosoftTokens,
  requestingXboxToken,
  requestingXstsToken,
  loggingIntoMinecraft,
}
