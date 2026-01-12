import 'package:kraft_launcher/account/data/microsoft_auth_api/microsoft_auth_api.dart';
import 'package:kraft_launcher/account/logic/launcher_minecraft_account/minecraft_account.dart';
import 'package:kraft_launcher/account/logic/microsoft/microsoft_refresh_token_expiration.dart';
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_resolver/minecraft_account_resolver_exceptions.dart'
    as minecraft_account_resolver_exceptions;
import 'package:kraft_launcher/common/logic/utils.dart';
import 'package:meta/meta.dart';
import 'package:minecraft_services_repository/minecraft_services_repository.dart'
    hide MinecraftCosmeticState, MinecraftSkinVariant;
import 'package:minecraft_services_repository/minecraft_services_repository.dart'
    as minecraft_services
    show MinecraftCosmeticState, MinecraftSkinVariant;

/// Performs the necessary steps to authenticate a Microsoft account
/// with Minecraft, including:
///
/// * Exchanging the Microsoft access token for an Xbox token,
/// * Requesting an XSTS token using the Xbox token,
/// * Logging into Minecraft using the XSTS credentials,
/// * Verifying Minecraft ownership,
/// * Fetching the Minecraft profile (ID, name, skins, capes).
///
/// Runs regardless of the Microsoft authentication method used
/// (device code, auth code), or when refreshing an existing account.
///
/// Stateless and pure; does not cache or persist any data.
class MinecraftAccountResolver {
  MinecraftAccountResolver({
    required MicrosoftAuthApi microsoftAuthApi,
    required MinecraftServicesRepository minecraftServicesRepository,
  }) : _microsoftAuthApi = microsoftAuthApi,
       _minecraftServicesRepository = minecraftServicesRepository;

  final MicrosoftAuthApi _microsoftAuthApi;
  final MinecraftServicesRepository _minecraftServicesRepository;

  Future<MinecraftAccount> resolve({
    required MicrosoftOAuthTokenResponse oauthTokenResponse,
    required ResolveMinecraftAccountProgressCallback onProgress,
  }) async {
    onProgress(ResolveMinecraftAccountProgress.requestingXboxToken);
    final xboxLiveTokenResponse = await _microsoftAuthApi.requestXboxLiveToken(
      oauthTokenResponse.accessToken,
    );

    onProgress(ResolveMinecraftAccountProgress.requestingXstsToken);
    final xstsTokenResponse = await _microsoftAuthApi.requestXSTSToken(
      xboxLiveTokenResponse.xboxToken,
    );

    // TODO: Avoid using valueOrThrow and refactor this class to return a Result
    //  rather than throwing exceptions. This workaround was made since other classes
    //  are not yet refactored.
    //  The codebase is being incrementally refactored to avoid
    //  throwing an [Exception] and to use the Result pattern with failures.
    //  Once this method returns a Result, all consumers must handle any failures.
    //  This workaround is used in all methods from the [MinecraftServicesRepository].
    //  URL: https://github.com/KraftLauncher/kraft-launcher/issues/8
    onProgress(ResolveMinecraftAccountProgress.loggingIntoMinecraft);
    final minecraftAuthResponse =
        (await _minecraftServicesRepository.authenticateWithXbox(
          xstsAccessToken: xstsTokenResponse.xboxToken,
          xstsUserHash: xstsTokenResponse.userHash,
        )).;

    onProgress(ResolveMinecraftAccountProgress.checkingMinecraftJavaOwnership);
    final ownsMinecraftJava =
        (await _minecraftServicesRepository.hasValidMinecraftJavaLicense(
          accessToken: minecraftAuthResponse.accessToken,
        )).;

    if (!ownsMinecraftJava) {
      throw const minecraft_account_resolver_exceptions.MinecraftJavaEntitlementAbsentException();
    }

    onProgress(ResolveMinecraftAccountProgress.fetchingProfile);
    final minecraftProfileResponse =
        (await _minecraftServicesRepository.fetchProfile(
          accessToken: minecraftAuthResponse.accessToken,
        )).;

    final newAccount = constructAccount(
      profileResponse: minecraftProfileResponse,
      oauthTokenResponse: oauthTokenResponse,
      loginResponse: minecraftAuthResponse,
      ownsMinecraftJava: ownsMinecraftJava,
    );

    return newAccount;
  }

  @visibleForTesting
  MinecraftAccount constructAccount({
    required MinecraftProfileResponse profileResponse,
    required MicrosoftOAuthTokenResponse oauthTokenResponse,
    required MinecraftLoginResponse loginResponse,
    required bool ownsMinecraftJava,
  }) {
    MinecraftCosmeticState toCosmeticState(
      minecraft_services.MinecraftCosmeticState api,
    ) => switch (api) {
      minecraft_services.MinecraftCosmeticState.active =>
        MinecraftCosmeticState.active,
      minecraft_services.MinecraftCosmeticState.inactive =>
        MinecraftCosmeticState.inactive,
    };
    return MinecraftAccount(
      id: profileResponse.id,
      username: profileResponse.name,
      accountType: AccountType.microsoft,
      microsoftAccountInfo: MicrosoftAccountInfo(
        microsoftRefreshToken: ExpirableToken(
          value: oauthTokenResponse.refreshToken,
          expiresAt: microsoftRefreshTokenExpiresAt(),
        ),
        minecraftAccessToken: ExpirableToken(
          value: loginResponse.accessToken,
          expiresAt: expiresInToExpiresAt(loginResponse.expiresIn),
        ),
        // Account created and logged in; re-authentication is not required
        reauthRequiredReason: null,
      ),
      skins: profileResponse.skins
          .map(
            (skin) => MinecraftSkin(
              id: skin.id,
              state: toCosmeticState(skin.state),
              url: skin.url,
              textureKey: skin.textureKey,
              variant: switch (skin.variant) {
                minecraft_services.MinecraftSkinVariant.classic =>
                  MinecraftSkinVariant.classic,
                minecraft_services.MinecraftSkinVariant.slim =>
                  MinecraftSkinVariant.slim,
              },
            ),
          )
          .toList(),
      capes: profileResponse.capes
          .map(
            (cape) => MinecraftCape(
              id: cape.id,
              state: toCosmeticState(cape.state),
              url: cape.url,
              alias: cape.alias,
            ),
          )
          .toList(),
      ownsMinecraftJava: ownsMinecraftJava,
    );
  }
}

enum ResolveMinecraftAccountProgress {
  requestingXboxToken,
  requestingXstsToken,
  loggingIntoMinecraft,
  checkingMinecraftJavaOwnership,
  fetchingProfile,
}

typedef ResolveMinecraftAccountProgressCallback =
    void Function(ResolveMinecraftAccountProgress progress);
