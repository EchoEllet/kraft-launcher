import 'dart:async';
import 'dart:io';

import 'package:kraft_launcher/account/data/redirect_http_server_handler/redirect_http_server_handler.dart';
import 'package:kraft_launcher/account/data/redirect_http_server_handler/redirect_http_server_handler_failures.dart';
import 'package:kraft_launcher/common/functional/result.dart';
import 'package:meta/meta.dart';

@visibleForTesting
abstract interface class HttpServerFactory {
  Future<HttpServer> bind(InternetAddress address, int port);
}

final class _DefaultHttpServerFactory implements HttpServerFactory {
  @override
  Future<HttpServer> bind(InternetAddress address, int port) {
    // WARNING: This static method cannot be unit tested, and an integration test is required
    // to verify the behavior. Please be cautious when making changes
    // to avoid regressions.
    return HttpServer.bind(address, port);
  }
}

/// An implementation of [RedirectHttpServerHandler] using [HttpServer] from `dart:io`.
///
/// See also:
/// * https://api.dart.dev/dart-io/HttpServer-class.html
/// * [RedirectHttpServerHandler]
final class DartRedirectHttpServerHandler implements RedirectHttpServerHandler {
  DartRedirectHttpServerHandler({
    @visibleForTesting HttpServerFactory? httpServerFactory,
  }) : _httpServerFactory = httpServerFactory ?? _DefaultHttpServerFactory();

  final HttpServerFactory _httpServerFactory;

  HttpServer? _server;

  HttpRequest? _request;

  @visibleForTesting
  HttpServer? get server => _server;

  @visibleForTesting
  set server(HttpServer? server) => _server = server;

  @visibleForTesting
  HttpRequest? get request => _request;

  @visibleForTesting
  set request(HttpRequest? request) => _request = request;

  @override
  bool get isRunning => _server != null;

  @override
  Future<EmptyResult<StartServerFailure>> start({required int port}) async {
    try {
      if (_server != null) {
        throw ServerAlreadyRunningError();
      }
      _server = await _httpServerFactory.bind(
        InternetAddress.loopbackIPv4,
        port,
      );

      return Result.emptySuccess();
    } on SocketException catch (e) {
      final osError = e.osError;
      if (osError == null) {
        return Result.failure(
          UnexpectedFailure('$OSError is null: ${e.message}.'),
        );
      }
      if (_isPortInUse(osError)) {
        return Result.failure(PortInUseFailure(port));
      }
      if (_isPermissionDenied(osError)) {
        return Result.failure(PermissionDeniedFailure(e.toString()));
      }
      return Result.failure(UnexpectedFailure(e.toString()));
    }
  }

  // Example of [OSError] on:
  // * Linux: `OS Error: Address already in use, errno = 98`
  // * macOS: `OS Error: Address already in use, errno = 48`
  // * Windows: `OS Error: Only one usage of each socket address (protocol/network address/port)`
  //
  // See also: https://learn.microsoft.com/en-us/windows/win32/winsock/windows-sockets-error-codes-2
  bool _isPortInUse(OSError osError) {
    final message = osError.message.toLowerCase();

    final messageIndicatesInUse =
        message.contains('one usage of each socket address') // Windows
        ||
        message.contains('in use') // macOS/Linux
        ||
        message.contains('eaddrinuse');

    final codeIndicatesInUse =
        osError.errorCode == 98 || // Linux
        osError.errorCode == 48 || // macOS
        osError.errorCode == 10048; // Windows (WSAEADDRINUSE)

    return messageIndicatesInUse || codeIndicatesInUse;
  }

  // Example of [OSError] on:
  // * macOS/Linux: `OS Error: Permission denied, errno = 13`
  // * Windows: **Unknown, the author of this code is unable to reproduce this issue.**
  //
  // **Note:** We were unable to reproduce this issue on
  // Windows 10/11 with Developer mode enabled/disabled.
  // Permission-denied detection on Windows uses the error codes documented by Microsoft:
  // https://learn.microsoft.com/en-us/windows/win32/winsock/windows-sockets-error-codes-2
  bool _isPermissionDenied(OSError osError) {
    final message = osError.message.toLowerCase();

    final messageIndicatesPermission =
        message.contains('permission denied') || message.contains('eacces');

    final codeIndicatesPermission =
        osError.errorCode == 13 || // macOS/Linux
        osError.errorCode == 10013; // Windows (WSAEACCES)

    return messageIndicatesPermission || codeIndicatesPermission;
  }

  @override
  Future<Map<String, String>?> waitForRequest() async {
    final server = _server;
    if (server == null) {
      throw ServerNotStartedError(methodName: 'waitForRequest');
    }
    if (_request != null) {
      throw WaitForRequestCalledTwiceError();
    }

    final request = await server._firstOrNull;
    if (request == null) {
      return null;
    }

    _request = request;
    return request.uri.queryParameters;
  }

  Future<void> _close() async {
    await _server?.close();
    _server = null;
    _request = null;
  }

  @override
  Future<void> respondAndClose(String html) async {
    final server = _server;
    if (server == null) {
      throw ServerNotStartedError(methodName: 'respondAndClose');
    }

    final request = _request;
    if (request == null) {
      throw RequestNotReceivedError();
    }
    final response = request.response;

    response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = ContentType.html
      ..write(html);
    await response.close();
    await _close();
  }

  @override
  Future<void> close() => _close();
}

extension _HttpServerExt on HttpServer {
  Future<HttpRequest?> get _firstOrNull {
    final completer = Completer<HttpRequest?>();
    late StreamSubscription<HttpRequest> serverSubscription;

    serverSubscription = listen(
      (request) {
        if (!completer.isCompleted) {
          completer.complete(request);
          serverSubscription.cancel();
        }
      },
      onDone: () {
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      },
      onError: (Object error, StackTrace stack) {
        if (!completer.isCompleted) {
          completer.completeError(error, stack);
        }
      },
      cancelOnError: true,
    );

    return completer.future;
  }
}

// For testing purposes, normally a [StateError] is thrown.

@visibleForTesting
final class ServerNotStartedError extends StateError {
  ServerNotStartedError({required String methodName})
    : super(
        '$methodName() was called before the server was started. '
        'Make sure start() has completed successfully before calling this method.',
      );
}

@visibleForTesting
final class WaitForRequestCalledTwiceError extends StateError {
  WaitForRequestCalledTwiceError()
    : super(
        'waitForRequest() was called more than once without closing the server '
        'or responding with respondAndClose().',
      );
}

@visibleForTesting
final class RequestNotReceivedError extends StateError {
  RequestNotReceivedError()
    : super(
        'respondAndClose() was called, but the $HttpRequest was not received (null). '
        'Make sure waitForRequest() was called and completed successfully before calling respondAndClose().',
      );
}

@visibleForTesting
final class ServerAlreadyRunningError extends StateError {
  ServerAlreadyRunningError()
    : super('Cannot start the server when it is already running.');
}
