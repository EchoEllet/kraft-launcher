import 'package:annotations/annotations.dart';
import 'package:result/result.dart';

sealed class MinecraftServicesFailure extends BaseFailure {
  const MinecraftServicesFailure(super.message);
}

final class ConnectionFailure extends MinecraftServicesFailure {
  const ConnectionFailure(String message)
    : super('Failed to connect to Minecraft services: $message');
}

final class UnexpectedFailure extends MinecraftServicesFailure {
  const UnexpectedFailure(String message)
    : super(
        'Unexpected failure while communicating with Minecraft services: $message',
      );
}

final class UnhandledServerResponseFailure extends MinecraftServicesFailure {
  const UnhandledServerResponseFailure(
    @debugOnlyInfra int statusCode,
    @debugOnlyInfra String? responseBody,
  ) : super(
        'Minecraft services returned an unhandled error ($statusCode):'
        '\n$responseBody',
      );
}

// Client errors

final class UnauthorizedAccessFailure extends MinecraftServicesFailure {
  const UnauthorizedAccessFailure()
    : super(
        'Unauthorized access. The Minecraft access token is either invalid or expired.',
      );
}

final class TooManyRequestsFailure extends MinecraftServicesFailure {
  const TooManyRequestsFailure()
    : super('Too many requests have been sent to the Minecraft Services API.');
}

final class AccountNotFoundFailure extends MinecraftServicesFailure {
  const AccountNotFoundFailure()
    : super('The Minecraft account was not found.');
}

final class InvalidSkinImageDataFailure extends MinecraftServicesFailure {
  const InvalidSkinImageDataFailure()
    : super('The uploaded skin image data is invalid.');
}

// Server errors

final class InternalServerFailure extends MinecraftServicesFailure {
  const InternalServerFailure(
    this.serverMessage,
    @debugOnlyInfra int statusCode,
  ) : super('Internal server error ($statusCode): $serverMessage');

  final String? serverMessage;
}

final class ServiceUnavailableFailure extends MinecraftServicesFailure {
  const ServiceUnavailableFailure({required this.retryAfterInSeconds})
    : super(
        'Service temporarily unavailable.'
        '${retryAfterInSeconds != null ? ' Retry after $retryAfterInSeconds seconds.' : ''}',
      );

  final int? retryAfterInSeconds;
}

// Data

/// A failure that occurs when the server returned data in an invalid format.
///
/// This indicates that the response could not be interpreted as structured data.
/// Typically happens when the server response is malformed or corrupted.
final class InvalidDataFormatFailure extends MinecraftServicesFailure {
  const InvalidDataFormatFailure(
    @debugOnlyInfra String responseBody,
    this.reason,
  ) : super('Invalid data format: $reason\nResponse body: $responseBody');

  /// Message describing why the data was considered invalid.
  final String reason;
}

/// A failure that occurs when the server returned data that does not match
/// the expected structure.
///
/// This indicates that the data format is valid, but the fields or types do not
/// match the expected model. This can happen if the server changes its data
/// structure or if the client is outdated.
final class UnexpectedDataStructureFailure extends MinecraftServicesFailure {
  const UnexpectedDataStructureFailure(@debugOnlyInfra Object data, this.reason)
    : super('Unexpected data structure: $reason\nData: $data');

  /// Message describing why the structure was considered unexpected.
  final String reason;
}
