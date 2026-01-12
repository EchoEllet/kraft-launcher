import 'package:kraft_launcher/common/functional/result.dart';

sealed class StartServerFailure extends BaseFailure {
  const StartServerFailure(super.message);
}

final class PortInUseFailure extends StartServerFailure {
  const PortInUseFailure(this.port) : super('Port is already in use: $port');

  final int port;
}

final class PermissionDeniedFailure extends StartServerFailure {
  const PermissionDeniedFailure(this.details)
    : super('Permission denied to bind the port: $details');

  final String details;
}

final class UnexpectedFailure extends StartServerFailure {
  const UnexpectedFailure(super.message);
}
