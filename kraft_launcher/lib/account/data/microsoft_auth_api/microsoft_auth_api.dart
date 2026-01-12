import 'package:kraft_launcher/account/data/microsoft_auth_api/auth_flows/microsoft_auth_code_flow_api.dart';
import 'package:kraft_launcher/account/data/microsoft_auth_api/auth_flows/microsoft_device_code_flow_api.dart';
import 'package:kraft_launcher/common/data/json.dart';
import 'package:meta/meta.dart';

/// A client for authenticating with Microsoft and Xbox using the following APIs:
///
/// * `login.live.com`
/// * `login.microsoftonline.com`
/// * `user.auth.xboxlive.com`
/// * `xsts.auth.xboxlive.com`
///
/// See also: https://minecraft.wiki/w/Microsoft_authentication
abstract interface class MicrosoftAuthApi
    implements MicrosoftAuthCodeFlowApi, MicrosoftDeviceCodeFlowApi {
  Future<XboxLiveAuthTokenResponse> requestXboxLiveToken(
    String microsoftAccessToken,
  );
  Future<XboxLiveAuthTokenResponse> requestXSTSToken(String xboxLiveToken);

  Future<MicrosoftOAuthTokenResponse> getNewTokensFromRefreshToken(
    String microsoftRefreshToken,
  );
}

// TODO: Extract these models from this file, ensure they are close to the data source
//  (raw data or source data rather than an app model) and map them in one place
//  to follow Architecture. Make similar changes to all APIs, including MicrosoftAuthApi.
//  See also: https://github.com/KraftLauncher/kraft-launcher/issues/8

// The success response when exchanging the auth code, device code or Microsoft
// refresh token for Microsoft tokens.
@immutable
class MicrosoftOAuthTokenResponse {
  const MicrosoftOAuthTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory MicrosoftOAuthTokenResponse.fromJson(JsonMap json) =>
      MicrosoftOAuthTokenResponse(
        accessToken: json['access_token']! as String,
        refreshToken: json['refresh_token']! as String,
        expiresIn: json['expires_in']! as int,
      );

  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  @override
  String toString() =>
      'MicrosoftOAuthTokenResponse(accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn)';
}

@immutable
class XboxLiveAuthTokenResponse {
  const XboxLiveAuthTokenResponse({
    required this.xboxToken,
    required this.userHash,
  });

  factory XboxLiveAuthTokenResponse.fromJson(JsonMap json) =>
      XboxLiveAuthTokenResponse(
        xboxToken: json['Token']! as String,
        userHash: () {
          final displayClaims = json['DisplayClaims']! as JsonMap;
          final xui = (displayClaims['xui']! as JsonList).cast<JsonMap>();
          final uhs = xui.first['uhs']! as String;
          return uhs;
        }(),
      );

  final String xboxToken;
  final String userHash;

  @override
  String toString() =>
      'XboxLiveAuthTokenResponse(xboxToken: $xboxToken, userHash: $userHash)';
}
