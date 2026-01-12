import 'package:kraft_launcher/account/data/microsoft_auth_api/microsoft_auth_api_exceptions.dart'
    as microsoft_auth;
import 'package:kraft_launcher/account/data/redirect_http_server_handler/redirect_http_server_handler_failures.dart'
    as redirect_http_server_handler;
import 'package:kraft_launcher/account/logic/launcher_minecraft_account/minecraft_account.dart';
import 'package:kraft_launcher/account/logic/microsoft/auth_flows/auth_code/microsoft_auth_code_flow_exceptions.dart'
    as auth_flow;
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_refresher/minecraft_account_refresher_exceptions.dart'
    as refresher;
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_resolver/minecraft_account_resolver_exceptions.dart'
    as resolver;
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_service/minecraft_account_service_exceptions.dart'
    as account_service;
import 'package:kraft_launcher/common/generated/l10n/app_localizations.dart';
import 'package:minecraft_services_repository/minecraft_services_repository.dart';

extension MinecraftAccountErrorMessages
    on account_service.MinecraftAccountServiceException {
  // TODO: Need to review this function and it's usages, should we throw Exception for special
  //  errors that needs to be handled and use the special error in there or use getMessage instead
  //  but always ensure to use the message from here directly.
  String getUserMessage(AppLocalizations loc) {
    return switch (this) {
      account_service.MicrosoftAuthCodeFlowException(:final exception) =>
        switch (exception) {
          auth_flow.AuthCodeMissingException() => loc.missingAuthCodeError,
          auth_flow.AuthCodeRedirectException(
            :final error,
            :final errorDescription,
          ) =>
            loc.authCodeLoginUnknownError(error, errorDescription),
          auth_flow.AuthCodeDeniedException() => loc.loginAttemptRejected,
          auth_flow.AuthCodeServerStartException(:final failure) =>
            switch (failure) {
              redirect_http_server_handler.PortInUseFailure(:final port) =>
                loc.authCodeServerStartFailurePortInUse(port),
              redirect_http_server_handler.PermissionDeniedFailure() =>
                loc.authCodeServerStartFailurePermissionDenied,
              redirect_http_server_handler.UnexpectedFailure() =>
                loc.authCodeServerStartFailureUnexpected,
            },
        },
      account_service.MinecraftAccountResolverException(:final exception) =>
        switch (exception) {
          resolver.MinecraftJavaEntitlementAbsentException() =>
            loc.minecraftOwnershipRequiredError,
        },
      account_service.MinecraftAccountRefresherException(:final exception) =>
        switch (exception) {
          refresher.InvalidMicrosoftRefreshTokenException() =>
            loc.sessionExpiredOrAccessRevoked,
          refresher.MicrosoftReAuthRequiredException() =>
            switch (exception.reason) {
              MicrosoftReauthRequiredReason.accessRevoked =>
                loc.reAuthRequiredDueToAccessRevoked,
              MicrosoftReauthRequiredReason.refreshTokenExpired =>
                loc.sessionExpired,
              MicrosoftReauthRequiredReason.tokensMissingFromSecureStorage =>
                loc.reAuthRequiredDueToMissingSecureAccountData,
              MicrosoftReauthRequiredReason.tokensMissingFromFileStorage =>
                loc.reAuthRequiredDueToMissingAccountTokensFromFileStorage,
            },
          refresher.WrappedMinecraftServicesException(:final wrapped) =>
            wrapped._getUserMessage(loc),
        },
      account_service.MicrosoftAuthApiException(:final exception) =>
        switch (exception) {
          // TODO(https://github.com/KraftLauncher/kraft-launcher/issues/8): unexpectedMicrosoftApiError is used incorrectly here, should be used
          //  only when the server respond with an unknown error,
          //  not when Dio throws DioException. This is being fixed as we refactor the API clients and add repositories.
          microsoft_auth.UnknownException() => loc.unexpectedMicrosoftApiError(
            exception.message,
          ),
          microsoft_auth.AuthCodeExpiredException() => loc.expiredAuthCodeError,

          microsoft_auth.XboxTokenMicrosoftAccessTokenExpiredException() =>
            loc.expiredMicrosoftAccessTokenError,

          microsoft_auth.InvalidRefreshTokenException() => throw StateError(
            'Expected ${microsoft_auth.InvalidRefreshTokenException} to be transformed into ${refresher.InvalidMicrosoftRefreshTokenException}. ${microsoft_auth.InvalidRefreshTokenException} should be caught and handled so this is likely a bug',
          ),
          microsoft_auth.TooManyRequestsException() =>
            loc.microsoftRequestLimitError,
          microsoft_auth.XstsErrorException(:final xstsError) =>
            switch (xstsError) {
              null =>
                exception.xErr != null
                    ? loc.xstsUnknownErrorWithDetails(
                        exception.xErr.toString(),
                        exception.message,
                      )
                    : loc.xstsUnknownError,
              microsoft_auth.XstsError.accountCreationRequired =>
                loc.xstsAccountCreationRequiredError,
              microsoft_auth.XstsError.regionUnavailable =>
                loc.xstsRegionNotSupportedError,
              microsoft_auth.XstsError.adultVerificationRequired =>
                loc.xstsAdultVerificationRequiredError,
              microsoft_auth.XstsError.ageVerificationRequired =>
                loc.xstsAgeVerificationRequiredError,
              microsoft_auth.XstsError.accountUnderAge =>
                loc.xstsRequiresAdultConsentRequiredError,
              microsoft_auth.XstsError.accountBanned =>
                loc.xstsAccountBannedError,
              microsoft_auth.XstsError.termsNotAccepted =>
                loc.xstsTermsNotAcceptedError,
            },
        },

      account_service.WrappedMinecraftServicesException(:final wrapped) =>
        wrapped._getUserMessage(loc),
    };
  }
}

extension on MinecraftServicesFailure {
  String _getUserMessage(AppLocalizations loc) => switch (this) {
    // TODO: IMPORTANT_TO_FIX: Need a system to keep showing the raw error message or maybe copy paste it?
    //  avoid unexpectedError(message), not user friendly to inline the error.
    //  See also: (https://github.com/KraftLauncher/kraft-launcher/issues/15)
    ConnectionFailure() => loc.connectionFailure,
    UnexpectedFailure() => loc.unexpectedFailureMessage,
    UnhandledServerResponseFailure() =>
      loc.minecraftServicesLoginUnhandledServerResponse,
    UnauthorizedAccessFailure() => loc.unauthorizedMinecraftAccessError,
    TooManyRequestsFailure() => loc.minecraftRequestLimitError,
    AccountNotFoundFailure() => loc.minecraftAccountNotFoundError,
    InvalidSkinImageDataFailure() => loc.invalidMinecraftSkinFile,
    InternalServerFailure() => loc.minecraftServicesLoginInternalServerError,
    ServiceUnavailableFailure() => loc.minecraftServicesApiUnavailable,
    InvalidDataFormatFailure() => loc.minecraftServicesLoginInvalidResponse,
    UnexpectedDataStructureFailure() =>
      loc.minecraftServicesLoginUnexpectedResponseDataStructure,
  };
}
