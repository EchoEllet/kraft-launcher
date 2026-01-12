import 'package:clock/clock.dart';
import 'package:kraft_launcher/account/data/image_cache_service/image_cache_service.dart';
import 'package:kraft_launcher/account/data/microsoft_auth_api/microsoft_auth_api.dart';
import 'package:kraft_launcher/account/data/microsoft_auth_api/microsoft_auth_api_exceptions.dart'
    as microsoft_auth_api_exceptions;
import 'package:kraft_launcher/account/logic/launcher_minecraft_account/minecraft_account.dart';
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_refresher/minecraft_account_refresher.dart';
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_refresher/minecraft_account_refresher_exceptions.dart'
    as refresher_exceptions;
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_resolver/minecraft_account_resolver.dart';
import 'package:kraft_launcher/account/logic/minecraft_skin_ext.dart';
import 'package:kraft_launcher/common/constants/constants.dart';
import 'package:minecraft_services_repository/minecraft_services_repository.dart';
import 'package:minecraft_services_repository/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../common/helpers/mocks.dart';
import '../../../../../common/test_constants.dart';
import '../../../../data/microsoft_auth_api/microsoft_auth_api_dummy_values.dart';
import '../../../../data/minecraft_account_utils.dart';
import '../../../../data/minecraft_dummy_accounts.dart';

void main() {
  late _MockImageCacheService mockImageCacheService;
  late MockMicrosoftAuthApi mockMicrosoftAuthApi;
  late FakeMinecraftServicesRepository fakeMinecraftServicesRepository;
  late _MockMinecraftAccountResolver mockAccountResolver;

  late MinecraftAccountRefresher refresher;

  setUp(() {
    mockImageCacheService = _MockImageCacheService();
    mockMicrosoftAuthApi = MockMicrosoftAuthApi();
    fakeMinecraftServicesRepository = FakeMinecraftServicesRepository();
    mockAccountResolver = _MockMinecraftAccountResolver();

    refresher = MinecraftAccountRefresher(
      imageCacheService: mockImageCacheService,
      microsoftAuthApi: mockMicrosoftAuthApi,
      minecraftServicesRepository: fakeMinecraftServicesRepository,
      accountResolver: mockAccountResolver,
    );

    when(
      () => mockMicrosoftAuthApi.getNewTokensFromRefreshToken(any()),
    ).thenAnswer((_) async => dummyMicrosoftOAuthTokenResponse);
  });

  group('refreshMicrosoftAccount', () {
    setUp(() {
      when(
        () => mockImageCacheService.evictFromCache(any()),
      ).thenAnswer((_) async => TestConstants.anyBool);

      when(
        () => mockAccountResolver.resolve(
          oauthTokenResponse: any(named: 'oauthTokenResponse'),
          onProgress: any(named: 'onProgress'),
        ),
      ).thenAnswer((_) async => createMinecraftAccount());
    });

    setUpAll(() {
      registerFallbackValue(dummyMicrosoftOAuthTokenResponse);
    });

    Future<MinecraftAccount> refreshMicrosoftAccount({
      MinecraftAccount? account,
      RefreshMinecraftAccountProgressCallback? onRefreshProgress,
      ResolveMinecraftAccountProgressCallback? onResolveAccountProgress,
    }) async {
      final accountBeforeRefresh =
          account ??
          createMinecraftAccount(
            accountType: AccountType.microsoft,
            microsoftAccountInfo: createMicrosoftAccountInfo(),
          );
      return refresher.refreshMicrosoftAccount(
        accountBeforeRefresh,
        onRefreshProgress: onRefreshProgress ?? (_) {},
        onResolveAccountProgress: onResolveAccountProgress ?? (_) {},
      );
    }

    test('throws $ArgumentError if $MicrosoftAccountInfo is null', () async {
      await expectLater(
        refreshMicrosoftAccount(
          account: createMinecraftAccount(isMicrosoftAccountInfoNull: true),
        ),
        throwsArgumentError,
      );
    });

    _testThrowsIfNeedsMicrosoftReAuth(
      (account) => refreshMicrosoftAccount(account: account),
    );

    _testThrowsIfRefreshTokenNull(
      (account) => refreshMicrosoftAccount(account: account),
    );

    test('emits expected progress events', () async {
      final progressEvents = <RefreshMinecraftAccountProgress>[];
      await refreshMicrosoftAccount(
        onRefreshProgress: (progress) => progressEvents.add(progress),
      );

      expect(progressEvents, [
        RefreshMinecraftAccountProgress.refreshingMicrosoftTokens,
      ]);
    });

    test(
      'calls $MicrosoftAuthApi with the Microsoft refresh token of the account',
      () async {
        const token = 'ExampleRefreshToken';
        await refreshMicrosoftAccount(
          account: createMinecraftAccount(
            microsoftAccountInfo: createMicrosoftAccountInfo(
              microsoftRefreshToken: createExpirableToken(value: token),
            ),
          ),
        );

        verify(
          () => mockMicrosoftAuthApi.getNewTokensFromRefreshToken(
            any(that: equals(token)),
          ),
        ).called(1);

        verifyNoMoreInteractions(mockMicrosoftAuthApi);
      },
    );

    test('deletes current cached Minecraft skin images', () async {
      const exampleUserId = 'Example Minecraft ID';
      final accountBeforeRefresh = createMinecraftAccount(
        id: exampleUserId,
        microsoftAccountInfo: createMicrosoftAccountInfo(
          microsoftRefreshToken: createExpirableToken(),
        ),
      );
      await refreshMicrosoftAccount(account: accountBeforeRefresh);

      verify(
        () => mockImageCacheService.evictFromCache(
          accountBeforeRefresh.fullSkinImageUrl,
        ),
      ).called(1);
      verify(
        () => mockImageCacheService.evictFromCache(
          accountBeforeRefresh.headSkinImageUrl,
        ),
      ).called(1);

      verifyNoMoreInteractions(mockImageCacheService);
    });

    test(
      'passes $MicrosoftOAuthTokenResponse correctly to $MinecraftAccountResolver',
      () async {
        final oauthTokenResponse = dummyMicrosoftOAuthTokenResponse;
        when(
          () => mockMicrosoftAuthApi.getNewTokensFromRefreshToken(any()),
        ).thenAnswer((_) async => oauthTokenResponse);

        await refreshMicrosoftAccount();
        verify(
          () => mockAccountResolver.resolve(
            oauthTokenResponse: any(
              named: 'oauthTokenResponse',
              that: same(oauthTokenResponse),
            ),
            onProgress: any(named: 'onProgress'),
          ),
        ).called(1);
      },
    );

    test(
      'passes $ResolveMinecraftAccountProgressCallback correctly to $MinecraftAccountResolver',
      () async {
        ResolveMinecraftAccountProgressCallback callback() => (_) {};

        final onProgress = callback();

        await refreshMicrosoftAccount(onResolveAccountProgress: onProgress);
        verify(
          () => mockAccountResolver.resolve(
            oauthTokenResponse: any(named: 'oauthTokenResponse'),
            onProgress: any(named: 'onProgress', that: same(onProgress)),
          ),
        ).called(1);
      },
    );

    test(
      'returns the $MinecraftAccount from $MinecraftAccountResolver',
      () async {
        final expectedAccount = createMinecraftAccount();
        when(
          () => mockAccountResolver.resolve(
            oauthTokenResponse: any(named: 'oauthTokenResponse'),
            onProgress: any(named: 'onProgress'),
          ),
        ).thenAnswer((_) async => expectedAccount);

        expect(await refreshMicrosoftAccount(), same(expectedAccount));

        verify(
          () => mockAccountResolver.resolve(
            oauthTokenResponse: any(named: 'oauthTokenResponse'),
            onProgress: any(named: 'onProgress'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockAccountResolver);
      },
    );

    test(
      'throws ${refresher_exceptions.InvalidMicrosoftRefreshTokenException} on ${microsoft_auth_api_exceptions.InvalidRefreshTokenException}',
      () async {
        when(
          () => mockAccountResolver.resolve(
            oauthTokenResponse: any(named: 'oauthTokenResponse'),
            onProgress: any(named: 'onProgress'),
          ),
        ).thenAnswer(
          (_) async =>
              throw const microsoft_auth_api_exceptions.InvalidRefreshTokenException(),
        );

        final account = createMinecraftAccount();
        await expectLater(
          refreshMicrosoftAccount(account: account),
          throwsA(
            isA<refresher_exceptions.InvalidMicrosoftRefreshTokenException>()
                .having(
                  (e) => e.updatedAccount,
                  'updatedAccount',
                  equals(
                    account.copyWith(
                      microsoftAccountInfo: account.microsoftAccountInfo
                          ?.copyWith(
                            reauthRequiredReason:
                                MicrosoftReauthRequiredReason.accessRevoked,
                          ),
                    ),
                  ),
                ),
          ),
        );
      },
    );

    test(
      'does not interact with $MinecraftServicesRepository or unrelated methods of $MicrosoftAuthApi',
      () async {
        await refreshMicrosoftAccount();

        verify(() => mockMicrosoftAuthApi.getNewTokensFromRefreshToken(any()));
        verifyNoMoreInteractions(mockMicrosoftAuthApi);

        fakeMinecraftServicesRepository.verifyZeroInteractions();
      },
    );
  });

  group('refreshMinecraftAccessTokenIfExpired', () {
    Future<MinecraftAccount> refreshMinecraftAccessTokenIfExpired({
      MinecraftAccount? account,
      RefreshMinecraftAccessTokenProgressCallback? onRefreshProgress,
    }) => refresher.refreshMinecraftAccessTokenIfExpired(
      account ?? createMinecraftAccount(),
      onRefreshProgress: onRefreshProgress ?? (_) {},
    );

    test('throws $ArgumentError when $MicrosoftAccountInfo is null', () async {
      await expectLater(
        refreshMinecraftAccessTokenIfExpired(
          account: createMinecraftAccount(isMicrosoftAccountInfoNull: true),
        ),
        throwsArgumentError,
      );
    });

    group('when Minecraft access token is expired', () {
      setUp(() {
        when(
          () => mockMicrosoftAuthApi.requestXboxLiveToken(any()),
        ).thenAnswer((_) async => dummyXboxLiveAuthTokenResponse);

        when(
          () => mockMicrosoftAuthApi.requestXSTSToken(any()),
        ).thenAnswer((_) async => dummyXboxLiveAuthTokenResponse);

        fakeMinecraftServicesRepository.whenAuthenticateWithXbox = (_) async {
          return MinecraftServicesResult.success(
            const MinecraftLoginResponse(
              accessToken: TestConstants.anyString,
              expiresIn: TestConstants.anyInt,
              username: TestConstants.anyString,
            ),
          );
        };
      });

      Future<MinecraftAccount> refreshWithExpiredMinecraftAccessToken({
        MinecraftAccount? account,
        RefreshMinecraftAccessTokenProgressCallback? onRefreshProgress,
        DateTime? fixedDateTime,
      }) {
        final clockTime = fixedDateTime ?? DateTime(2025, 5, 23, 10, 16);

        account ??= createMinecraftAccount();
        final expiredAccount = account.copyWith(
          microsoftAccountInfo: account.microsoftAccountInfo!.copyWith(
            minecraftAccessToken: account
                .microsoftAccountInfo!
                .minecraftAccessToken
                .copyWith(
                  // Simulate expiration
                  expiresAt: clockTime.subtract(const Duration(days: 1)),
                ),
          ),
        );

        return withClock(Clock.fixed(clockTime), () {
          return refreshMinecraftAccessTokenIfExpired(
            account: expiredAccount,
            onRefreshProgress: onRefreshProgress ?? (_) {},
          );
        });
      }

      _testThrowsIfNeedsMicrosoftReAuth(
        (account) => refreshWithExpiredMinecraftAccessToken(account: account),
      );

      _testThrowsIfRefreshTokenNull(
        (account) => refreshWithExpiredMinecraftAccessToken(account: account),
      );

      test(
        'does not interact with $MinecraftAccountResolver or $ImageCacheService',
        () async {
          await refreshWithExpiredMinecraftAccessToken();

          verifyZeroInteractions(mockAccountResolver);
          verifyZeroInteractions(mockImageCacheService);
        },
      );

      test('throws a ${refresher_exceptions.WrappedMinecraftServicesException} '
          'with the original failure when Xbox authentication fails', () async {
        // Avoid const to ensure unique instance for reference equality in test when using same().
        // ignore: prefer_const_constructors
        final expectedFailure = InvalidSkinImageDataFailure();
        fakeMinecraftServicesRepository.whenAuthenticateWithXbox = (_) async {
          return MinecraftServicesResult.failure(expectedFailure);
        };

        await expectLater(
          refreshMinecraftAccessTokenIfExpired(),
          throwsA(
            isA<refresher_exceptions.WrappedMinecraftServicesException>()
                .having((e) => e.wrapped, 'wrapped', same(expectedFailure)),
          ),
        );
      });

      test(
        'emits refresh progress events in the correct sequence when refreshing',
        () async {
          final progressEvents = <RefreshMinecraftAccessTokenProgress>[];

          await refreshWithExpiredMinecraftAccessToken(
            onRefreshProgress: (progress) => progressEvents.add(progress),
          );

          expect(progressEvents, [
            RefreshMinecraftAccessTokenProgress.refreshingMicrosoftTokens,
            RefreshMinecraftAccessTokenProgress.requestingXboxToken,
            RefreshMinecraftAccessTokenProgress.requestingXstsToken,
            RefreshMinecraftAccessTokenProgress.loggingIntoMinecraft,
          ]);
        },
      );

      test(
        'uses Microsoft refresh token from existing account to obtain a new access token',
        () async {
          final account = createMinecraftAccount();
          await refreshWithExpiredMinecraftAccessToken(account: account);

          verify(
            () => mockMicrosoftAuthApi.getNewTokensFromRefreshToken(
              account.microsoftAccountInfo!.microsoftRefreshToken.value!,
            ),
          );
        },
      );

      test(
        'obtains a new Microsoft access token and forwards it to Xbox Live token request',
        () async {
          const microsoftAccessToken = 'example-access-token';

          when(
            () => mockMicrosoftAuthApi.getNewTokensFromRefreshToken(any()),
          ).thenAnswer(
            (_) async => const MicrosoftOAuthTokenResponse(
              accessToken: microsoftAccessToken,
              refreshToken: TestConstants.anyString,
              expiresIn: TestConstants.anyInt,
            ),
          );

          await refreshWithExpiredMinecraftAccessToken();

          verify(
            () =>
                mockMicrosoftAuthApi.requestXboxLiveToken(microsoftAccessToken),
          );
        },
      );

      test(
        'obtains a new Xbox live token and forwards it to XSTS token request',
        () async {
          const xboxLiveToken = 'example-xbox-live-token';

          when(
            () => mockMicrosoftAuthApi.requestXboxLiveToken(any()),
          ).thenAnswer(
            (_) async => const XboxLiveAuthTokenResponse(
              xboxToken: xboxLiveToken,
              userHash: TestConstants.anyString,
            ),
          );
          await refreshWithExpiredMinecraftAccessToken();

          verify(() => mockMicrosoftAuthApi.requestXSTSToken(xboxLiveToken));
        },
      );

      test(
        'obtains a new Xbox token and user hash and forwards it to Minecraft authentication request',
        () async {
          const expectedXstsToken = 'example-xsts-token';
          const expectedXstsUserHash = 'example-xsts-user-hash';

          when(() => mockMicrosoftAuthApi.requestXSTSToken(any())).thenAnswer(
            (_) async => const XboxLiveAuthTokenResponse(
              xboxToken: expectedXstsToken,
              userHash: expectedXstsUserHash,
            ),
          );

          await refreshWithExpiredMinecraftAccessToken();

          final call =
              fakeMinecraftServicesRepository.authenticateWithXboxCalls.first;

          expect(call.xstsAccessToken, expectedXstsToken);
          expect(call.xstsUserHash, expectedXstsUserHash);
        },
      );

      test(
        'calls APIs with the expected number of times to prevent unnecessary or duplicate requests',
        () async {
          await refreshWithExpiredMinecraftAccessToken();

          verify(
            () => mockMicrosoftAuthApi.getNewTokensFromRefreshToken(any()),
          ).called(1);
          verify(
            () => mockMicrosoftAuthApi.requestXboxLiveToken(any()),
          ).called(1);
          verify(() => mockMicrosoftAuthApi.requestXSTSToken(any())).called(1);
          verifyNoMoreInteractions(mockMicrosoftAuthApi);

          fakeMinecraftServicesRepository.verifyMethodCallCounts(
            authenticateWithXbox: 1,
          );
        },
      );

      test('returns a new account instance with updated tokens', () async {
        const microsoftOauthResponse = MicrosoftOAuthTokenResponse(
          accessToken: 'example-access-token',
          refreshToken: 'example-refresh-token',
          expiresIn: 4500,
        );

        const minecraftLoginResponse = MinecraftLoginResponse(
          username: 'example-7b1ff0da-a75b-507f-5c39-7262la7dl1f2',
          accessToken: 'example-minecraft-access-token',
          expiresIn: 9600,
        );

        when(
          () => mockMicrosoftAuthApi.getNewTokensFromRefreshToken(any()),
        ).thenAnswer((_) async => microsoftOauthResponse);
        when(() => mockMicrosoftAuthApi.requestXboxLiveToken(any())).thenAnswer(
          (_) async => const XboxLiveAuthTokenResponse(
            xboxToken: 'example-token',
            userHash: 'example-user-hash',
          ),
        );
        when(() => mockMicrosoftAuthApi.requestXSTSToken(any())).thenAnswer(
          (_) async => const XboxLiveAuthTokenResponse(
            xboxToken: 'example-xsts-token',
            userHash: 'example-xsts-user-hash',
          ),
        );
        fakeMinecraftServicesRepository.whenAuthenticateWithXbox = (_) async {
          return MinecraftServicesResult.success(minecraftLoginResponse);
        };

        final expiredAccount = MinecraftDummyAccount.account;
        final fixedDateTime = DateTime(2030, 10, 5, 10);

        final refreshedAccount = await refreshWithExpiredMinecraftAccessToken(
          account: expiredAccount,
          fixedDateTime: fixedDateTime,
        );
        expect(refreshedAccount, isNot(same(expiredAccount)));

        final expectedMicrosoftRefreshTokenExpiresAt = fixedDateTime.add(
          const Duration(days: MicrosoftConstants.refreshTokenExpiresInDays),
        );

        final expectedMinecraftAccessTokenExpiresAt = fixedDateTime.add(
          Duration(seconds: minecraftLoginResponse.expiresIn),
        );
        expect(
          refreshedAccount
              .microsoftAccountInfo
              ?.microsoftRefreshToken
              .expiresAt,
          expectedMicrosoftRefreshTokenExpiresAt,
        );

        expect(
          refreshedAccount.microsoftAccountInfo?.minecraftAccessToken.expiresAt,
          expectedMinecraftAccessTokenExpiresAt,
        );

        final expiredMicrosoftAccountInfo = expiredAccount.microsoftAccountInfo;

        expect(
          refreshedAccount,
          expiredAccount.copyWith(
            microsoftAccountInfo: expiredMicrosoftAccountInfo?.copyWith(
              microsoftRefreshToken: expiredMicrosoftAccountInfo
                  .microsoftRefreshToken
                  .copyWith(
                    expiresAt: expectedMicrosoftRefreshTokenExpiresAt,
                    value: microsoftOauthResponse.refreshToken,
                  ),
              minecraftAccessToken: expiredMicrosoftAccountInfo
                  .minecraftAccessToken
                  .copyWith(
                    expiresAt: expectedMinecraftAccessTokenExpiresAt,
                    value: minecraftLoginResponse.accessToken,
                  ),
            ),
          ),
          reason:
              'Should copy the expired account with the new tokens without any other changes',
        );
      });
    });

    group('when Minecraft access token is not expired', () {
      Future<MinecraftAccount> refreshWithValidMinecraftAccessToken({
        MinecraftAccount? account,
        RefreshMinecraftAccessTokenProgressCallback? onRefreshProgress,
        DateTime? fixedDateTime,
      }) {
        final clockTime = fixedDateTime ?? DateTime(2025, 5, 23, 10, 16);

        account ??= createMinecraftAccount();
        final expiredAccount = account.copyWith(
          microsoftAccountInfo: account.microsoftAccountInfo!.copyWith(
            minecraftAccessToken: account
                .microsoftAccountInfo!
                .minecraftAccessToken
                .copyWith(
                  // Simulate valid token by setting its expiration in the future
                  expiresAt: clockTime.add(const Duration(days: 1)),
                ),
          ),
        );

        return withClock(Clock.fixed(clockTime), () {
          return refreshMinecraftAccessTokenIfExpired(
            account: expiredAccount,
            onRefreshProgress: onRefreshProgress ?? (_) {},
          );
        });
      }

      test(
        'does not interact with $MinecraftAccountResolver or $ImageCacheService',
        () async {
          await refreshWithValidMinecraftAccessToken();

          verifyZeroInteractions(mockAccountResolver);
          verifyZeroInteractions(mockImageCacheService);
        },
      );

      test('returns same account if access token has not expired', () async {
        final account = await refreshWithValidMinecraftAccessToken(
          onRefreshProgress: (_) => fail(
            'Should not refresh the account when the Minecraft access token has not expired.',
          ),
        );
        expect(
          account,
          same(account),
          reason:
              'Should return the original account if the Minecraft access token has not expired',
        );
      });

      test('does not interact with any classes', () async {
        await refreshWithValidMinecraftAccessToken();

        verifyZeroInteractions(mockAccountResolver);
        fakeMinecraftServicesRepository.verifyZeroInteractions();
        verifyZeroInteractions(mockMicrosoftAuthApi);
        verifyZeroInteractions(mockImageCacheService);
      });
    });
  });
}

void _testThrowsIfNeedsMicrosoftReAuth(
  Future<void> Function(MinecraftAccount account) performRefresh,
) {
  test(
    'throws ${refresher_exceptions.MicrosoftReAuthRequiredException} with correct $MicrosoftReauthRequiredReason if not null',
    () async {
      for (final reason in MicrosoftReauthRequiredReason.values) {
        await expectLater(
          performRefresh(
            createMinecraftAccount(
              microsoftAccountInfo: createMicrosoftAccountInfo(
                reauthRequiredReason: reason,
              ),
            ),
          ),
          throwsA(
            isA<refresher_exceptions.MicrosoftReAuthRequiredException>().having(
              (e) => e.reason,
              'reason',
              equals(reason),
            ),
          ),
        );
      }
    },
  );
}

void _testThrowsIfRefreshTokenNull(
  Future<void> Function(MinecraftAccount account) performRefresh,
) {
  test('throws $StateError when Microsoft refresh token is null', () async {
    await expectLater(
      performRefresh(
        createMinecraftAccount(
          microsoftAccountInfo: createMicrosoftAccountInfo(
            microsoftRefreshToken: createExpirableToken(isValueNull: true),
          ),
        ),
      ),
      throwsA(isA<StateError>()),
    );
  });
}

class _MockImageCacheService extends Mock implements ImageCacheService {}

class _MockMinecraftAccountResolver extends Mock
    implements MinecraftAccountResolver {}
