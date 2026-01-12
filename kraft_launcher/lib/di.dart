// TODO: IMPORTANT_TO_FIX Fix the issue of having to import api_client, http and minecraft_services_client deps
//  just to create an instance of something. We want full decoupling from these,
//  we should not add them to pubspec.yaml of this app package!
import 'package:api_client/api_client.dart' show ApiClient, HttpApiClient;
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http show Client;
import 'package:image_picker/image_picker.dart';
import 'package:kraft_launcher/account/data/image_cache_service/default_image_cache_service.dart';
import 'package:kraft_launcher/account/data/image_cache_service/image_cache_service.dart';
import 'package:kraft_launcher/account/data/launcher_minecraft_account/local_file_storage/account_file_storage.dart';
import 'package:kraft_launcher/account/data/launcher_minecraft_account/secure_storage/secure_account_storage.dart';
import 'package:kraft_launcher/account/data/linux_secret_service/dbus_linux_secret_service_checker.dart';
import 'package:kraft_launcher/account/data/linux_secret_service/linux_secret_service_checker.dart';
import 'package:kraft_launcher/account/data/microsoft_auth_api/microsoft_auth_api.dart';
import 'package:kraft_launcher/account/data/microsoft_auth_api/microsoft_auth_api_impl.dart';
import 'package:kraft_launcher/account/data/redirect_http_server_handler/dart_redirect_http_server_handler.dart';
import 'package:kraft_launcher/account/data/redirect_http_server_handler/redirect_http_server_handler.dart';
import 'package:kraft_launcher/account/logic/launcher_minecraft_account/account_repository.dart';
import 'package:kraft_launcher/account/logic/microsoft/auth_flows/auth_code/microsoft_auth_code_flow.dart';
import 'package:kraft_launcher/account/logic/microsoft/auth_flows/device_code/microsoft_device_code_flow.dart';
import 'package:kraft_launcher/account/logic/microsoft/auth_flows/microsoft_oauth_flow_controller.dart';
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_refresher/minecraft_account_refresher.dart';
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_resolver/minecraft_account_resolver.dart';
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_service/minecraft_account_service.dart';
import 'package:kraft_launcher/account/logic/offline_account/minecraft_offline_account_factory.dart';
import 'package:kraft_launcher/account/logic/platform_secure_storage_support.dart';
import 'package:kraft_launcher/account/ui/account_cubit/account_cubit.dart';
import 'package:kraft_launcher/account/ui/microsoft_auth_cubit/microsoft_auth_cubit.dart';
import 'package:kraft_launcher/common/data/network/dio_factory.dart';
import 'package:kraft_launcher/common/logic/app_data_paths.dart';
import 'package:kraft_launcher/settings/data/settings_file_storage.dart';
import 'package:kraft_launcher/settings/logic/settings_repository.dart';
import 'package:kraft_launcher/settings/ui/cubit/settings_cubit.dart';
import 'package:meta/meta.dart';
import 'package:minecraft_services_client/minecraft_services_client.dart'
    show HttpMinecraftServicesApiClient, MinecraftServicesApiClient;
import 'package:minecraft_services_repository/minecraft_services_repository.dart';
// Provider is used for dependency injection, not state management.
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart'
    show MultiProvider, Provider, ReadContext;

class AppDi extends StatelessWidget {
  const AppDi({super.key, required this.child, required this.appDataPaths});

  final Widget child;
  final AppDataPaths appDataPaths;

  @override
  Widget build(BuildContext context) {
    return _CommonProviders(
      appDataPaths: appDataPaths,
      child: _AccountFeatureProviders(
        child: _SettingsFeatureProviders(child: child),
      ),
    );
  }
}

class _CommonProviders extends StatelessWidget {
  const _CommonProviders({required this.child, required this.appDataPaths});

  final Widget child;
  final AppDataPaths appDataPaths;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => ImagePicker()),
        Provider(create: (context) => const FlutterSecureStorage()),
        Provider.value(value: appDataPaths),
        Provider<Dio>(
          create: (context) => DioFactory.newClient(),
          dispose: (_, value) => value.close(),
        ),
        Provider<http.Client>(
          create: (context) => http.Client(),
          dispose: (context, value) => value.close(),
        ),
        Provider<ApiClient>(create: (context) => HttpApiClient(context.read())),
      ],
      child: child,
    );
  }
}

abstract class _FeatureProviders extends StatelessWidget {
  const _FeatureProviders({required this.child});

  final Widget child;

  @nonVirtual
  @override
  Widget build(BuildContext context) => _dataLayer(
    child: _logicLayer(child: _uiLayer(child: child)),
  );

  Widget _dataLayer({required Widget child});
  Widget _logicLayer({required Widget child});
  Widget _uiLayer({required Widget child});
}

// NOTE: The difference between RepositoryProvider and Provider is semantic.

class _AccountFeatureProviders extends _FeatureProviders {
  const _AccountFeatureProviders({required super.child});

  @override
  Widget _dataLayer({required Widget child}) => MultiProvider(
    providers: [
      Provider<MicrosoftAuthApi>(
        create: (context) => MicrosoftAuthApiImpl(dio: context.read()),
      ),
      Provider<MinecraftServicesApiClient>(
        create: (context) => HttpMinecraftServicesApiClient(
          apiClient: context.read<ApiClient>(),
        ),
      ),
      Provider<MinecraftServicesRepository>(
        create: (context) => DefaultMinecraftServicesRepository(
          apiClient: context.read<MinecraftServicesApiClient>(),
        ),
      ),
      Provider<ImageCacheService>(
        create: (context) => DefaultImageCacheService(),
      ),
      Provider<AccountFileStorage>(
        create: (context) =>
            AccountFileStorage.fromAppDataPaths(context.read()),
      ),
      Provider(
        create: (context) =>
            SecureAccountStorage(flutterSecureStorage: context.read()),
      ),
      Provider<LinuxSecretServiceChecker>(
        create: (context) => DbusLinuxSecretServiceChecker(),
      ),
      Provider<RedirectHttpServerHandler>(
        create: (context) => DartRedirectHttpServerHandler(),
        dispose: (_, value) => value.close(),
      ),
    ],
    child: child,
  );

  @override
  Widget _logicLayer({required Widget child}) => MultiProvider(
    providers: [
      Provider<PlatformSecureStorageSupport>(
        create: (context) => PlatformSecureStorageSupport(
          linuxSecretServiceChecker: context.read(),
        ),
      ),
      RepositoryProvider<AccountRepository>(
        create: (context) => AccountRepository(
          accountFileStorage: context.read(),
          secureAccountStorage: context.read(),
          secureStorageSupport: context.read(),
        ),
        dispose: (repository) => repository.dispose(),
      ),
      Provider<MinecraftAccountResolver>(
        create: (context) => MinecraftAccountResolver(
          microsoftAuthApi: context.read(),
          minecraftServicesRepository: context.read(),
        ),
      ),
      Provider(
        create: (context) => MicrosoftAuthCodeFlow(
          microsoftAuthApi: context.read(),
          redirectHttpServerHandler: context.read(),
        ),
        dispose: (_, value) => value.closeServer(),
      ),
      Provider(
        create: (context) =>
            MicrosoftDeviceCodeFlow(microsoftAuthApi: context.read()),
        dispose: (_, value) => value.cancelPollingTimer(),
      ),
      Provider(
        create: (context) => MicrosoftOAuthFlowController(
          microsoftAuthCodeFlow: context.read(),
          microsoftDeviceCodeFlow: context.read(),
        ),
      ),
      Provider(
        create: (context) => MinecraftAccountRefresher(
          imageCacheService: context.read(),
          microsoftAuthApi: context.read(),
          minecraftServicesRepository: context.read(),
          accountResolver: context.read(),
        ),
      ),
      Provider<MinecraftAccountService>(
        create: (context) => MinecraftAccountService(
          accountRepository: context.read<AccountRepository>(),
          microsoftOAuthFlowController: context.read(),
          minecraftAccountResolver: context.read(),
          minecraftAccountRefresher: context.read(),
        ),
      ),
      Provider(create: (context) => MinecraftOfflineAccountFactory()),
    ],
    child: child,
  );

  @override
  Widget _uiLayer({required Widget child}) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AccountCubit(
          accountRepository: context.read(),
          offlineAccountFactory: context.read(),
        ),
      ),
      BlocProvider(
        create: (context) => MicrosoftAuthCubit(
          minecraftAccountService: context.read(),
          // TODO: No bloc/cubit should depends on the other, avoid? See: https://bloclibrary.dev/architecture/#bloc-to-bloc-communication,
          //  See also: https://bloclibrary.dev/architecture/#connecting-blocs-through-domain and AccountRepository, this should be fixed once other related TODOs are fixed in AccountCubit and MicrosoftAuthCubit
          accountCubit: context.read(),
          secureStorageSupport: context.read(),
        ),
      ),
    ],
    child: child,
  );
}

class _SettingsFeatureProviders extends _FeatureProviders {
  const _SettingsFeatureProviders({required super.child});

  @override
  Widget _dataLayer({required Widget child}) => MultiProvider(
    providers: [
      Provider(
        create: (context) =>
            SettingsFileStorage.fromAppDataPaths(context.read()),
      ),
    ],
    child: child,
  );

  @override
  Widget _logicLayer({required Widget child}) => MultiProvider(
    providers: [
      RepositoryProvider(
        create: (context) =>
            SettingsRepository(settingsFileStorage: context.read()),
      ),
    ],
    child: child,
  );

  @override
  Widget _uiLayer({required Widget child}) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => SettingsCubit(settingsRepository: context.read()),
        lazy: true,
      ),
    ],
    child: child,
  );
}
