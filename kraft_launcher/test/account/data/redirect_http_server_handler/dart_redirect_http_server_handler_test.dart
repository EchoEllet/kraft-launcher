import 'dart:async';
import 'dart:io';

import 'package:kraft_launcher/account/data/redirect_http_server_handler/dart_redirect_http_server_handler.dart';
import 'package:kraft_launcher/account/data/redirect_http_server_handler/redirect_http_server_handler_failures.dart';
import 'package:kraft_launcher/common/functional/result.dart';
import 'package:kraft_launcher/common/logic/platform_check.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../common/test_constants.dart';

void main() {
  late _MockHttpServer mockHttpServer;
  late _FakeHttpServerFactory fakeHttpServerFactory;

  late DartRedirectHttpServerHandler redirectHttpServerHandler;

  setUp(() {
    mockHttpServer = _MockHttpServer();
    fakeHttpServerFactory = _FakeHttpServerFactory(
      mockHttpServer: mockHttpServer,
    );

    redirectHttpServerHandler = DartRedirectHttpServerHandler(
      httpServerFactory: fakeHttpServerFactory,
    );

    when(() => mockHttpServer.close()).thenAnswer((_) async {
      return null;
    });
  });

  // Causes `_firstOrNull` to return null by simulating the case where the
  // server is closed before receiving any [HttpRequest].
  Future<void> withNoHttpRequest(Future<void> Function() run) async {
    when(
      () => mockHttpServer.listen(
        any(),
        cancelOnError: any(named: 'cancelOnError'),
        onDone: any(named: 'onDone'),
        onError: any(named: 'onError'),
      ),
    ).thenAnswer((invocation) {
      final onDone = invocation.namedArguments[#onDone] as void Function()?;

      scheduleMicrotask(() {
        if (onDone != null) {
          onDone();
        }
      });

      // Return a dummy subscription (no real stream)
      return const Stream<HttpRequest>.empty().listen(null);
    });

    await run();
  }

  // Causes `_firstOrNull` to return a not-null value by simulating the case where the
  // [HttpRequest] is received successfully.
  Future<void> withHttpRequest(
    HttpRequest request,
    Future<void> Function() run,
  ) async {
    when(
      () => mockHttpServer.listen(
        any(),
        cancelOnError: any(named: 'cancelOnError'),
        onDone: any(named: 'onDone'),
        onError: any(named: 'onError'),
      ),
    ).thenAnswer((invocation) {
      final onData =
          invocation.positionalArguments[0] as void Function(HttpRequest);
      final onDone = invocation.namedArguments[#onDone] as void Function()?;
      final onError = invocation.namedArguments[#onError] as Function?;
      final cancelOnError = invocation.namedArguments[#cancelOnError] as bool?;

      final stream = Stream.value(request);
      final subscription = stream.listen(
        onData,
        onDone: onDone,
        onError: onError,
        cancelOnError: cancelOnError,
      );

      // Return a dummy subscription (no real stream)
      return subscription;
    });

    await run();
  }

  Future<void> requireHttpServerNotNull() async {
    redirectHttpServerHandler.server = mockHttpServer;

    if (redirectHttpServerHandler.server == null) {
      fail('Test setup failed: server should be be not null');
    }
  }

  Future<void> requireHttpServerNull() async {
    redirectHttpServerHandler.server = null;

    if (redirectHttpServerHandler.server != null) {
      fail('Test setup failed: server should be null');
    }
  }

  Future<void> requireHttpRequestNotNull() async {
    final mock = _MockHttpRequest();
    when(() => mock.uri).thenAnswer((_) => TestConstants.anyUri);

    redirectHttpServerHandler.request = mock;

    if (redirectHttpServerHandler.request == null) {
      fail('Test setup failed: request should be not null');
    }
  }

  test(
    'internal $HttpServer is initially null before server is started',
    () => expect(redirectHttpServerHandler.server, null),
  );

  group('isRunning', () {
    test('returns true when $HttpServer is not null', () async {
      await requireHttpServerNotNull();

      expect(redirectHttpServerHandler.isRunning, true);
    });

    test('returns false when $HttpServer is null', () async {
      await requireHttpServerNull();

      expect(redirectHttpServerHandler.isRunning, false);
    });
  });

  group('start', () {
    test(
      'throws $ServerAlreadyRunningError when $HttpServer is not null',
      () async {
        await requireHttpServerNotNull();

        await expectLater(
          redirectHttpServerHandler.start(port: _dummyPort),
          throwsA(isA<ServerAlreadyRunningError>()),
        );
      },
    );

    test(
      'uses ${InternetAddress.loopbackIPv4} (127.0.0.1) for the internet address',
      () async {
        await redirectHttpServerHandler.start(port: _dummyPort);

        expect(
          fakeHttpServerFactory.capturedInternetAddress,
          InternetAddress.loopbackIPv4,
        );
      },
    );

    test('passes port argument to $HttpServerFactory', () async {
      const expectedPort = 45565;
      await redirectHttpServerHandler.start(port: 45565);

      expect(fakeHttpServerFactory.capturedPort, expectedPort);
    });

    test(
      'sets $HttpServer to result from $HttpServerFactory on success',
      () async {
        await redirectHttpServerHandler.start(port: _dummyPort);

        expect(redirectHttpServerHandler.server, mockHttpServer);
      },
    );

    test('returns $SuccessResult when server starts successfully', () async {
      expect(
        await redirectHttpServerHandler.start(port: _dummyPort),
        isA<EmptySuccessResult<StartServerFailure>>(),
      );
    });

    group('exception-to-failure mapping', () {
      test(
        'returns $UnexpectedFailure when $SocketException has null $OSError',
        () async {
          fakeHttpServerFactory.throwsException = const SocketException(
            TestConstants.anyString,
            osError: null,
          );

          final result = await redirectHttpServerHandler.start(
            port: _dummyPort,
          );

          expect(result.failureOrNull, isA<UnexpectedFailure>());
        },
      );

      for (final desktopPlatform in DesktopPlatform.values) {
        test(
          'returns $PortInUseFailure when port is already in use on ${desktopPlatform.name}',
          () async {
            final osError = switch (desktopPlatform) {
              DesktopPlatform.linux => const OSError(
                'Address already in use',
                98,
              ),
              DesktopPlatform.macOS => const OSError(
                'Address already in use',
                48,
              ),
              DesktopPlatform.windows => const OSError(
                'Only one usage of each socket address (protocol/network address/port)',
                10048,
              ),
            };
            fakeHttpServerFactory.throwsException = SocketException(
              TestConstants.anyString,
              osError: osError,
            );

            final result = await redirectHttpServerHandler.start(
              port: _dummyPort,
            );

            expect(result.failureOrNull, isA<PortInUseFailure>());
          },
        );
      }

      for (final desktopPlatform in DesktopPlatform.values) {
        test(
          'returns $PermissionDeniedFailure when permission is denied on ${desktopPlatform.name}',
          () async {
            const linuxMacOs = OSError('Permission denied', 13);
            final osError = switch (desktopPlatform) {
              DesktopPlatform.linux => linuxMacOs,
              DesktopPlatform.macOS => linuxMacOs,
              DesktopPlatform.windows =>
                // We were unable to reproduce this issue on Windows
                // and the exact message of [OSError] that will be thrown in this case is unknown.
                const OSError('Permission denied', 10013),
            };
            fakeHttpServerFactory.throwsException = SocketException(
              TestConstants.anyString,
              osError: osError,
            );

            final result = await redirectHttpServerHandler.start(
              port: _dummyPort,
            );

            expect(result.failureOrNull, isA<PermissionDeniedFailure>());
          },
        );
      }

      test(
        'returns $UnexpectedFailure for unhandled $SocketException cases',
        () async {
          fakeHttpServerFactory.throwsException = const SocketException(
            TestConstants.anyString,
            osError: OSError(TestConstants.anyString, TestConstants.anyInt),
          );

          final result = await redirectHttpServerHandler.start(
            port: _dummyPort,
          );

          expect(result.failureOrNull, isA<UnexpectedFailure>());
        },
      );
    });
  });

  group('waitForRequest', () {
    test('throws $ServerNotStartedError when $HttpServer is null', () async {
      await requireHttpServerNull();

      await expectLater(
        redirectHttpServerHandler.waitForRequest(),
        throwsA(isA<ServerNotStartedError>()),
      );
    });

    test(
      'throws $WaitForRequestCalledTwiceError when $HttpRequest is not null',
      () async {
        await requireHttpServerNotNull();
        await requireHttpRequestNotNull();

        await expectLater(
          redirectHttpServerHandler.waitForRequest(),
          throwsA(isA<WaitForRequestCalledTwiceError>()),
        );
      },
    );

    test(
      'returns null when server is closed before receiving the first $HttpRequest',
      () async {
        await requireHttpServerNotNull();

        await withNoHttpRequest(() async {
          expect(await redirectHttpServerHandler.waitForRequest(), null);
        });
      },
    );

    test('sets $HttpRequest to not null', () async {
      await requireHttpServerNotNull();

      final mock = _MockHttpRequest();
      when(() => mock.uri).thenAnswer((_) => TestConstants.anyUri);

      await withHttpRequest(mock, () async {
        await redirectHttpServerHandler.waitForRequest();
      });

      expect(redirectHttpServerHandler.request, same(mock));
    });

    test('returns the query parameters from received $HttpRequest', () async {
      await requireHttpServerNotNull();

      final queryParams = {TestConstants.anyString: TestConstants.anyString};
      final mock = _MockHttpRequest();
      when(() => mock.uri).thenAnswer((_) => Uri(queryParameters: queryParams));

      await withHttpRequest(mock, () async {
        expect(await redirectHttpServerHandler.waitForRequest(), queryParams);
      });

      // Ensure no unnecessary interactions
      verify(() => mock.uri).called(1);
      verifyNoMoreInteractions(mock);
    });
  });

  group('respondAndClose', () {
    test('throws $ServerNotStartedError when $HttpServer is null', () async {
      await requireHttpServerNull();

      await expectLater(
        redirectHttpServerHandler.respondAndClose(_dummyHtml),
        throwsA(isA<ServerNotStartedError>()),
      );
    });

    test('throws $RequestNotReceivedError when $HttpRequest is null', () async {
      await requireHttpServerNotNull();

      await expectLater(
        redirectHttpServerHandler.respondAndClose(_dummyHtml),
        throwsA(isA<RequestNotReceivedError>()),
      );
    });

    group('on responding', () {
      setUp(() async {
        await requireHttpServerNotNull();
      });

      Future<String?> withHttpResponse(
        _MockHttpResponse mockResponse,
        Future<void> Function() run, {
        _MockHttpHeaders? mockHttpHeaders,
      }) async {
        String? response;

        when(() => mockResponse.write(any())).thenAnswer((invocation) {
          response = invocation.positionalArguments[0] as String?;
        });
        when(() => mockResponse.close()).thenAnswer((_) async => null);

        final mockHeaders = mockHttpHeaders ?? _MockHttpHeaders();
        when(() => mockResponse.headers).thenReturn(mockHeaders);

        final mockHttpRequest = _MockHttpRequest();
        when(() => mockHttpRequest.response).thenReturn(mockResponse);
        when(() => mockHttpRequest.uri).thenReturn(TestConstants.anyUri);

        redirectHttpServerHandler.request = mockHttpRequest;

        await withHttpRequest(mockHttpRequest, run);

        return response;
      }

      test('sets status code to 200 (OK)', () async {
        final mockResponse = _MockHttpResponse();

        await withHttpResponse(
          mockResponse,
          () => redirectHttpServerHandler.respondAndClose(_dummyHtml),
        );

        verify(() => mockResponse.statusCode = HttpStatus.ok).called(1);
      });

      test('sets content-type header to text/html', () async {
        final mockResponse = _MockHttpResponse();
        final mockHttpHeaders = _MockHttpHeaders();

        await withHttpResponse(
          mockResponse,
          () => redirectHttpServerHandler.respondAndClose(_dummyHtml),
          mockHttpHeaders: mockHttpHeaders,
        );

        verify(() => mockHttpHeaders.contentType = ContentType.html).called(1);
        verify(() => mockResponse.headers).called(1);
      });

      test('writes the provided HTML to response body', () async {
        const expectedHtml = '<a>Hello, World!<a/>';

        final capturedHtml = await withHttpResponse(
          _MockHttpResponse(),
          () => redirectHttpServerHandler.respondAndClose(expectedHtml),
        );
        expect(capturedHtml, expectedHtml);
      });

      test('closes response', () async {
        final mockResponse = _MockHttpResponse();

        await withHttpResponse(
          mockResponse,
          () => redirectHttpServerHandler.respondAndClose(_dummyHtml),
        );

        verify(() => mockResponse.close()).called(1);
      });

      test('closes server', () async {
        await withHttpResponse(
          _MockHttpResponse(),
          () => redirectHttpServerHandler.respondAndClose(_dummyHtml),
        );

        verify(() => mockHttpServer.close()).called(1);
        expect(redirectHttpServerHandler.server, null);
        expect(redirectHttpServerHandler.request, null);

        verifyNoMoreInteractions(mockHttpServer);
      });

      test('interacts with $HttpRequest correctly', () async {
        final mockResponse = _MockHttpResponse();
        final mockHttpHeaders = _MockHttpHeaders();

        await withHttpResponse(
          mockResponse,
          () => redirectHttpServerHandler.respondAndClose(_dummyHtml),
          mockHttpHeaders: mockHttpHeaders,
        );

        verify(() => mockHttpHeaders.contentType = any()).called(1);
        verify(() => mockResponse.headers).called(1);
        verify(() => mockResponse.statusCode = any()).called(1);
        verify(() => mockResponse.write(any())).called(1);
        verify(() => mockResponse.close()).called(1);

        // Avoid unnecessary interactions
        verifyNoMoreInteractions(mockResponse);
        verifyNoMoreInteractions(mockHttpHeaders);
      });
    });
  });

  group('close', () {
    test('closes the $HttpServer if not null', () async {
      when(() => mockHttpServer.close()).thenAnswer((_) async {});
      await requireHttpServerNotNull();

      await redirectHttpServerHandler.close();

      verify(() => mockHttpServer.close()).called(1);
      verifyNoMoreInteractions(mockHttpServer);
    });

    test('sets the $HttpServer to null', () async {
      await requireHttpServerNotNull();

      await redirectHttpServerHandler.close();

      expect(redirectHttpServerHandler.server, null);
    });

    test('sets the $HttpRequest to null', () async {
      await requireHttpRequestNotNull();

      await redirectHttpServerHandler.close();

      expect(redirectHttpServerHandler.request, null);
    });

    test(
      'completes and performs no action when $HttpServer is not running',
      () async {
        await requireHttpServerNull();

        await expectLater(redirectHttpServerHandler.close(), completes);

        verifyZeroInteractions(mockHttpServer);
      },
    );
  });
}

class _MockHttpServer extends Mock implements HttpServer {}

class _MockHttpRequest extends Mock implements HttpRequest {}

class _MockHttpResponse extends Mock implements HttpResponse {}

class _MockHttpHeaders extends Mock implements HttpHeaders {}

final class _FakeHttpServerFactory implements HttpServerFactory {
  _FakeHttpServerFactory({required this.mockHttpServer});

  final _MockHttpServer mockHttpServer;

  InternetAddress? capturedInternetAddress;
  int? capturedPort;
  Exception? throwsException;

  @override
  Future<HttpServer> bind(InternetAddress address, int port) async {
    capturedInternetAddress = address;
    capturedPort = port;
    if (throwsException case final e?) {
      throw e;
    }
    return mockHttpServer;
  }
}

const _dummyPort = 35565;

const _dummyHtml = TestConstants.anyString;
