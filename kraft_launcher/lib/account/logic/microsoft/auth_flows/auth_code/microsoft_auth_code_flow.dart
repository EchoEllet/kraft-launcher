/// @docImport 'package:kraft_launcher/account/logic/microsoft/auth_flows/device_code/microsoft_device_code_flow.dart';
/// @docImport 'package:kraft_launcher/account/logic/microsoft/auth_flows/microsoft_oauth_flow_controller.dart';
library;

import 'dart:async';

import 'package:kraft_launcher/account/data/microsoft_auth_api/microsoft_auth_api.dart';
import 'package:kraft_launcher/account/data/redirect_http_server_handler/redirect_http_server_handler.dart';
import 'package:kraft_launcher/account/data/redirect_http_server_handler/redirect_http_server_handler_failures.dart';
import 'package:kraft_launcher/account/logic/microsoft/auth_flows/auth_code/microsoft_auth_code_flow_exceptions.dart'
    as microsoft_auth_code_flow_exceptions;
import 'package:kraft_launcher/common/constants/constants.dart';
import 'package:kraft_launcher/common/constants/project_info_constants.dart';
import 'package:kraft_launcher/common/functional/result.dart';
import 'package:kraft_launcher/common/logic/app_logger.dart';
import 'package:meta/meta.dart';

// TODO: Provide a code example for this class.
//  This is a draft and incomplete (need changes, improvements or fixes):
/// ```dart
/// final flow = MicrosoftAuthCodeFlow(...);
///
/// final response = await flow.run(
///   onProgress: (progress) {
///     // Show progress to the user...
///   },
///   onAuthCodeLoginUrlAvailable: (url) {
///     // The user needs to open this [url] in the browser
///     // to complete authentication in Microsoft site.
///   },
///   // For localization purposes, the messages are not hardcoded.
///   authCodeResponsePageVariants: ...
/// );
///
/// // Await Microsoft's redirect callback containing success or error data.
/// if (response == null) {
///   // The server was closed before receiving the response.
///   // The server typically gets closed when the process is cancelled by the user.
///   // This should not happen when the user rejects or completes the login
///   // and Microsoft redirects to the server with the success or error data.
/// }
/// ```

/// Handles Microsoft OAuth authorization code flow (not specific to Minecraft).
///
/// Provides the URL for the user to open on Microsoft’s site—usually
/// opened in the user’s system browser.
///
/// Runs a temporary HTTP server to receive the redirect after login,
/// which may contain an authorization code on success,
/// or error code and description in case of failure.
///
/// Responds with an HTML page indicating success, rejection,
/// missing authorization code, or unknown errors.
///
/// On successful authentication, exchanges the authorization code
/// for Microsoft OAuth access and refresh tokens.
///
/// See also:
///
/// * [MicrosoftDeviceCodeFlow], for Microsoft device code authentication.
/// * [MicrosoftOAuthFlowController], that manages both [MicrosoftAuthCodeFlow] and [MicrosoftDeviceCodeFlow].
class MicrosoftAuthCodeFlow {
  MicrosoftAuthCodeFlow({
    // TODO: Refactor MicrosoftAuthCodeFlow to be fully independent of MicrosoftAuthApi,
    //  by returning only the auth code, and leaving the responsibility of using that auth code
    //  to get the Microsoft access token and refresh token to the callers.
    //  IMPORTANT_TO_FIX Actually, no, that would be inconsistent with MicrosoftDeviceCodeFlow,
    //  The higher level componenet should gives the common result that is token response,
    //  should this class gives the auth code or the token response? Higher level componenets
    //  should not care.
    required MicrosoftAuthApi microsoftAuthApi,
    required RedirectHttpServerHandler redirectHttpServerHandler,
  }) : _redirectHttpServerHandler = redirectHttpServerHandler,
       _microsoftAuthApi = microsoftAuthApi;

  final MicrosoftAuthApi _microsoftAuthApi;

  /// Handles the temporary HTTP server used for receiving Microsoft's OAuth redirect.
  /// Microsoft redirects to this server with the auth code after user login.
  final RedirectHttpServerHandler _redirectHttpServerHandler;

  // Exposed for an integration test.
  @visibleForTesting
  static const serverPort = ProjectInfoConstants.microsoftLoginRedirectPort;

  bool get _isServerRunning => _redirectHttpServerHandler.isRunning;

  Future<EmptyResult<StartServerFailure>> _startServer() async {
    if (_redirectHttpServerHandler.isRunning) {
      throw StateError(
        'Cannot start Microsoft OAuth flow: the redirect server is already running. '
        'Ensure run() is not called concurrently.',
      );
    }

    final result = await _redirectHttpServerHandler.start(port: serverPort);
    AppLogger.i('Starting the Microsoft Auth Code server');
    return result;
  }

  Future<bool> closeServer() async {
    final running = _isServerRunning;

    if (running) {
      await _redirectHttpServerHandler.close();
      AppLogger.i('Closing the Microsoft Auth Code server');

      return true;
    }
    return false;
  }

  Future<MicrosoftOAuthTokenResponse?> run({
    required AuthCodeProgressCallback onProgress,
    required AuthCodeLoginUrlAvailableCallback onAuthCodeLoginUrlAvailable,
    // The page content is not hardcoded for localization.
    required MicrosoftAuthCodeResponsePageVariants authCodeResponsePageVariants,
  }) async {
    final failure = (await _startServer()).failureOrNull;
    if (failure != null) {
      AppLogger.e(
        'Failed to start the temporary server that is required to handle '
        'the Microsoft auth code flow login result: ${failure.message}',
        failure.message,
      );
      throw microsoft_auth_code_flow_exceptions.AuthCodeServerStartException(
        failure,
      );
    }

    final authCodeLoginUrl = _microsoftAuthApi.userLoginUrlWithAuthCode();

    onProgress(MicrosoftAuthCodeProgress.waitingForUserLogin);
    onAuthCodeLoginUrlAvailable(authCodeLoginUrl);

    // Await Microsoft's redirect callback containing success or error data.
    final queryParams = await _redirectHttpServerHandler.waitForRequest();
    if (queryParams == null) {
      // Null indicates the server closed before receiving a redirect.
      // The server typically gets closed when the user cancels the login process,
      // for example, by closing the login dialog or press "cancel" button.
      return null;
    }

    final code =
        queryParams[MicrosoftConstants.loginRedirectAuthCodeQueryParamName];

    final error =
        queryParams[MicrosoftConstants.loginRedirectErrorQueryParamName];
    final errorDescription =
        queryParams[MicrosoftConstants
            .loginRedirectErrorDescriptionQueryParamName];

    if (error != null) {
      if (error == MicrosoftConstants.loginRedirectAccessDeniedErrorCode) {
        await _redirectHttpServerHandler.respondAndClose(
          buildAuthCodeResultHtmlPage(
            authCodeResponsePageVariants.accessDenied,
            isSuccess: false,
          ),
        );
        throw const microsoft_auth_code_flow_exceptions.AuthCodeDeniedException();
      }

      await _redirectHttpServerHandler.respondAndClose(
        buildAuthCodeResultHtmlPage(
          authCodeResponsePageVariants.unknownError(
            error,
            errorDescription.toString(),
          ),
          isSuccess: false,
        ),
      );
      throw microsoft_auth_code_flow_exceptions.AuthCodeRedirectException(
        error: error,
        errorDescription: errorDescription.toString(),
      );
    }
    if (code == null) {
      await _redirectHttpServerHandler.respondAndClose(
        buildAuthCodeResultHtmlPage(
          authCodeResponsePageVariants.missingAuthCode,
          isSuccess: false,
        ),
      );
      throw const microsoft_auth_code_flow_exceptions.AuthCodeMissingException();
    }
    await _redirectHttpServerHandler.respondAndClose(
      buildAuthCodeResultHtmlPage(
        authCodeResponsePageVariants.approved,
        isSuccess: true,
      ),
    );

    onProgress(MicrosoftAuthCodeProgress.exchangingAuthCode);

    final oauthTokenResponse = await _microsoftAuthApi
        .exchangeAuthCodeForTokens(code);

    return oauthTokenResponse;
  }
}

@immutable
class MicrosoftAuthCodeResponsePageContent {
  const MicrosoftAuthCodeResponsePageContent({
    required this.pageTitle,
    required this.title,
    required this.subtitle,
    required this.pageLangCode,
    required this.pageDir,
  });
  final String pageTitle;
  final String title;
  final String subtitle;
  final String pageLangCode;
  final String pageDir;
}

@immutable
class MicrosoftAuthCodeResponsePageVariants {
  const MicrosoftAuthCodeResponsePageVariants({
    required this.approved,
    required this.accessDenied,
    required this.missingAuthCode,
    required this.unknownError,
  });

  final MicrosoftAuthCodeResponsePageContent approved;
  final MicrosoftAuthCodeResponsePageContent accessDenied;
  final MicrosoftAuthCodeResponsePageContent missingAuthCode;
  final MicrosoftAuthCodeResponsePageContent Function(
    String errorCode,
    String errorDescription,
  )
  unknownError;
}

/// Builds the HTML response, which will be shown to the user in the browser.
///
/// The auth code flow requires a redirect URI,
/// the app temporarily starts a local server to handle the redirect request,
/// which contains the auth code needed to complete login.
@visibleForTesting
String buildAuthCodeResultHtmlPage(
  MicrosoftAuthCodeResponsePageContent content, {
  required bool isSuccess,
}) =>
    '''
<!DOCTYPE html>
<html lang="${content.pageLangCode}" dir="${content.pageDir}">
<head>
  <meta charset="UTF-8" />
  <title>${content.pageTitle}</title>
  <style>
    html, body {
      margin: 0;
      padding: 0;
      height: 100%;
      width: 100%;
      background: #1e1e1e;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      color: #d4d4d4;
    }
    .container {
      text-align: center;
    }
    .logo {
      width: 150px;
      height: auto;
      margin-bottom: 1.5rem;
    }
    h1 {
      font-size: 1.5rem;
      margin: 0;
      color: #ffffff;
    }
    p {
      margin-top: 0.5rem;
      font-size: 1rem;
      color: #c5c5c5;
    }
    a {
      color: #3794ff;
      text-decoration: none;
    }
    a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
  <div class="container">
    <img src="${ProjectInfoConstants.microsoftAuthHtmlImageUrl}" alt="Logo" class="logo" />
    <h1 style="font-size: 2rem; margin-top: 1px; color: ${isSuccess ? '#22c55e' : '#ef4444'};">
      ${content.title} <span>${isSuccess ? '✔' : '✖'}</span>
    </h1>
    <p>${content.subtitle}</p>
  </div>
</body>
</html>
''';

enum MicrosoftAuthCodeProgress { waitingForUserLogin, exchangingAuthCode }

typedef AuthCodeProgressCallback =
    void Function(MicrosoftAuthCodeProgress progress);

typedef AuthCodeLoginUrlAvailableCallback =
    void Function(String authCodeLoginUrl);
