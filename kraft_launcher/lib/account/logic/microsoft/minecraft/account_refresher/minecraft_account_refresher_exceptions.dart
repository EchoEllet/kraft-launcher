/// @docImport 'package:kraft_launcher/account/data/microsoft_auth_api/microsoft_auth_api.dart';
/// @docImport 'package:kraft_launcher/account/logic/microsoft/minecraft/account_refresher/minecraft_account_refresher.dart';
library;

import 'package:kraft_launcher/account/data/microsoft_auth_api/microsoft_auth_api_exceptions.dart'
    as microsoft_auth_api_exceptions;
import 'package:kraft_launcher/account/logic/launcher_minecraft_account/minecraft_account.dart';
import 'package:meta/meta.dart';
import 'package:minecraft_services_repository/minecraft_services_repository.dart';

@immutable
sealed class MinecraftAccountRefresherException implements Exception {
  const MinecraftAccountRefresherException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The exception [microsoft_auth_api_exceptions.InvalidRefreshTokenException] originates
/// from [MicrosoftAuthApi] and will be
/// caught in [MinecraftAccountRefresher] and transformed into this exception,
/// which includes the updated account that indicates it needs re-authentication.
/// and this transformation is specific to [MinecraftAccountRefresher].
final class InvalidMicrosoftRefreshTokenException
    extends MinecraftAccountRefresherException {
  InvalidMicrosoftRefreshTokenException(this.updatedAccount)
    : super(
        'Microsoft OAuth Refresh token expired or access revoked. The account ${updatedAccount.id} needs re-authentication.',
      );

  /// The updated account that indicates it needs re-authentication.
  final MinecraftAccount updatedAccount;
}

final class MicrosoftReAuthRequiredException
    extends MinecraftAccountRefresherException {
  MicrosoftReAuthRequiredException(this.reason)
    : super('Microsoft Re-authentication is required. Reason: ${reason.name}');

  final MicrosoftReauthRequiredReason reason;
}

/// Wraps a [MinecraftServicesFailure] inside this exception for backward
/// compatibility.
///
/// The codebase is being incrementally refactored to avoid throwing an [Exception]
/// and to use the Result pattern with failures. See also:
/// https://github.com/KraftLauncher/kraft-launcher/issues/8
///
/// This class primarily exists to handle a [MinecraftServicesFailure] that was
/// caught and then rethrown as an exception instead of breaking the existing
/// method signature.
final class WrappedMinecraftServicesException
    extends MinecraftAccountRefresherException {
  WrappedMinecraftServicesException(this.wrapped) : super(wrapped.message);

  final MinecraftServicesFailure wrapped;
}
