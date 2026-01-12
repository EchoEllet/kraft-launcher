import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kraft_launcher/account/data/microsoft_auth_api/microsoft_auth_api_exceptions.dart'
    as microsoft_auth_api_exceptions;
import 'package:kraft_launcher/account/logic/microsoft/auth_flows/auth_code/microsoft_auth_code_flow.dart';
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_resolver/minecraft_account_resolver_exceptions.dart';
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_service/minecraft_account_service_exceptions.dart'
    as minecraft_account_service_exceptions;
import 'package:kraft_launcher/account/logic/microsoft/minecraft/account_service/minecraft_auth_progress.dart';
import 'package:kraft_launcher/account/ui/microsoft_auth_cubit/microsoft_auth_cubit.dart';
import 'package:kraft_launcher/account/ui/minecraft_java_entitlement_absent_dialog.dart';
import 'package:kraft_launcher/account/ui/utils/auth_progress_messages.dart';
import 'package:kraft_launcher/account/ui/utils/minecraft_account_error_messages.dart';
import 'package:kraft_launcher/common/constants/constants.dart';
import 'package:kraft_launcher/common/constants/project_info_constants.dart';
import 'package:kraft_launcher/common/ui/utils/build_context_ext.dart';
import 'package:kraft_launcher/common/ui/utils/scaffold_messenger_ext.dart';
import 'package:kraft_launcher/common/ui/widgets/alert_card.dart';
import 'package:kraft_launcher/common/ui/widgets/copy_code_block.dart';
import 'package:kraft_launcher/settings/ui/cubit/settings_cubit.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginWithMicrosoftDialog extends StatefulWidget {
  const LoginWithMicrosoftDialog({super.key, required this.isReAuthentication});

  /// Whether this dialog was launched for re-authentication.
  ///
  /// Affects only UI labels, not functionality.
  final bool isReAuthentication;

  @override
  State<LoginWithMicrosoftDialog> createState() =>
      _LoginWithMicrosoftDialogState();

  static void show(BuildContext context, {bool isReAuthentication = false}) =>
      showDialog<void>(
        context: context,
        builder: (context) =>
            LoginWithMicrosoftDialog(isReAuthentication: isReAuthentication),
      );
}

class _LoginWithMicrosoftDialogState extends State<LoginWithMicrosoftDialog> {
  late final MicrosoftAuthCubit _microsoftAuthCubit;

  @override
  Widget build(BuildContext context) {
    // NOTE: If you refactor to allow closing the dialog before login completes,
    // ensure BlocListener is also updated to handle results correctly,
    // since it lives inside this dialog and will be destroyed when the dialog closes.
    // dialog and will be destroyed with it.
    final isLoggingIn = context.select(
      (MicrosoftAuthCubit cubit) =>
          cubit.state.loginStatus == MicrosoftLoginStatus.loading &&
          cubit.state.loginProgress !=
              MinecraftAuthProgress.waitingForUserLogin,
    );

    return PopScope(
      canPop: !isLoggingIn,
      child: _MicrosoftLoginListener(
        child: AlertDialog(
          title: Text(
            widget.isReAuthentication
                ? context.loc.updateMicrosoftAccount
                : context.loc.addMicrosoftAccount,
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 300,
              minHeight: 100,
              maxWidth: 350,
            ),
            child: const SingleChildScrollView(child: _DialogContent()),
          ),
          actions: [
            TextButton(
              onPressed: isLoggingIn ? null : () => context.pop(),
              child: Text(context.loc.cancel),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _microsoftAuthCubit = context.read<MicrosoftAuthCubit>();
    _microsoftAuthCubit.requestLoginWithMicrosoftDeviceCode();
  }

  @override
  void dispose() {
    _microsoftAuthCubit.closeAuthCodeServer();
    _microsoftAuthCubit.cancelDeviceCodePollingTimer();
    _microsoftAuthCubit.resetLoginStatus();
    super.dispose();
  }
}

class _DialogContent extends StatelessWidget {
  const _DialogContent();

  @override
  Widget build(BuildContext context) {
    final loginStatus = context.select(
      (MicrosoftAuthCubit cubit) => cubit.state.loginStatus,
    );
    if (loginStatus == MicrosoftLoginStatus.loading ||
        // While the listener is processing and about to close the dialog,
        // keep showing the loading state even after a success to avoid a UI flash.
        loginStatus.isSuccess) {
      return const _LoadingIndicator();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocSelector<MicrosoftAuthCubit, MicrosoftAuthState, bool?>(
          selector: (state) => state.supportsSecureStorage,
          builder: (context, supportsSecureStorage) {
            if (!(supportsSecureStorage ?? false)) {
              return const _SecureStorageUnsupportedWarning();
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 6),
        const _AuthCodeSection(),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                context.loc.or,
                style: context.theme.textTheme.bodyMedium,
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 8),
        const _DeviceCodeSection(),
      ],
    );
  }
}

class _DeviceCodeSection extends StatefulWidget {
  const _DeviceCodeSection();

  @override
  State<_DeviceCodeSection> createState() => _DeviceCodeSectionState();
}

class _DeviceCodeSectionState extends State<_DeviceCodeSection> {
  final _microsoftDeviceLinkTapRecognizer = TapGestureRecognizer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(text: '${context.loc.deviceCodeStepVisit} '),
              TextSpan(
                text: MicrosoftConstants.microsoftDeviceCodeLink,
                recognizer: _microsoftDeviceLinkTapRecognizer
                  ..onTap = () => launchUrl(
                    Uri.parse(MicrosoftConstants.microsoftDeviceCodeLink),
                  ),
                style: TextStyle(color: context.theme.colorScheme.primary),
              ),

              TextSpan(text: '\n${context.loc.deviceCodeStepEnter}'),
            ],
          ),
        ),
        const SizedBox(height: 8),

        Builder(
          builder: (context) {
            final deviceCodeStatus = context.select(
              (MicrosoftAuthCubit cubit) => cubit.state.deviceCodeStatus,
            );
            return switch (deviceCodeStatus) {
              MicrosoftDeviceCodeStatus.idle => const SizedBox.shrink(),
              MicrosoftDeviceCodeStatus.requestingCode => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: LinearProgressIndicator(),
              ),
              MicrosoftDeviceCodeStatus.polling => CopyCodeBlock(
                code: context.select(
                  (MicrosoftAuthCubit cubit) =>
                      cubit.state.requestedDeviceCodeOrThrow,
                ),
              ),
              MicrosoftDeviceCodeStatus.expired => Column(
                spacing: 8,
                children: [
                  Text(
                    context.loc.loginDeviceCodeExpired,
                    style: context.theme.textTheme.titleMedium,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => context
                        .read<MicrosoftAuthCubit>()
                        .requestLoginWithMicrosoftDeviceCode(),
                    label: Text(context.loc.tryAgain),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              MicrosoftDeviceCodeStatus.declined => Column(
                spacing: 8,
                children: [
                  Text(
                    context.loc.loginAttemptRejected,
                    style: context.theme.textTheme.titleMedium,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => context
                        .read<MicrosoftAuthCubit>()
                        .requestLoginWithMicrosoftDeviceCode(),
                    label: Text(context.loc.tryAgain),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            };
          },
        ),
        const SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              SizedBox(
                height: 140,
                width: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: QrImageView(
                    backgroundColor: Colors.white,
                    data: MicrosoftConstants.microsoftDeviceCodeLink,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.loc.deviceCodeQrInstruction,
                style: context.theme.textTheme.bodySmall?.copyWith(
                  color: context.theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _microsoftDeviceLinkTapRecognizer.dispose();
    super.dispose();
  }
}

class _AuthCodeSection extends StatelessWidget {
  const _AuthCodeSection();

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {
        // TODO: An improvement we could make is:
        //  1. Avoid requiring pageDir and pageLangCode in each instance of MicrosoftAuthCodeResponsePageContent.
        //  It should be required only once.
        //  2. Avoid requiring pageLangCode and reading SettingsCubit, instead
        //  make MicrosoftAuthCubit dependent on SettingsRepository and access the value internally.
        final pageDir = Directionality.of(context).name;
        final pageLangCode = context
            .read<SettingsCubit>()
            .state
            .settingsOrThrow
            .general
            .appLanguage
            .localeCode;
        context.read<MicrosoftAuthCubit>().loginWithMicrosoftAuthCode(
          authCodeResponsePageVariants: MicrosoftAuthCodeResponsePageVariants(
            approved: MicrosoftAuthCodeResponsePageContent(
              pageTitle: context.loc.authCodeRedirectPageLoginSuccessTitle,
              title: context.loc.authCodeRedirectPageLoginSuccessTitle,
              subtitle: context.loc.authCodeRedirectPageLoginSuccessMessage(
                ProjectInfoConstants.displayName,
              ),
              pageDir: pageDir,
              pageLangCode: pageLangCode,
            ),
            accessDenied: MicrosoftAuthCodeResponsePageContent(
              pageTitle: context.loc.errorOccurred,
              title: context.loc.errorOccurred,
              subtitle: context.loc.loginAttemptRejected,
              pageLangCode: pageLangCode,
              pageDir: pageDir,
            ),
            missingAuthCode: MicrosoftAuthCodeResponsePageContent(
              pageTitle: context.loc.errorOccurred,
              title: context.loc.errorOccurred,
              subtitle: context.loc.missingAuthCodeError,
              pageLangCode: pageLangCode,
              pageDir: pageDir,
            ),
            unknownError: (errorCode, errorDescription) =>
                MicrosoftAuthCodeResponsePageContent(
                  pageTitle: context.loc.errorOccurred,
                  title: context.loc.errorOccurred,
                  subtitle: context.loc.authCodeLoginUnknownError(
                    errorCode,
                    errorDescription,
                  ),
                  pageLangCode: pageLangCode,
                  pageDir: pageDir,
                ),
          ),
        );
      },
      label: Text(context.loc.signInViaBrowser),
      icon: const Icon(Icons.open_in_browser),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    final loginProgress = context.select(
      (MicrosoftAuthCubit cubit) => cubit.state.loginProgress,
    );
    final authFlow = context.select(
      (MicrosoftAuthCubit cubit) => cubit.state.authFlow,
    );
    final message = loginProgress.getMessage(context.loc);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(height: 16),

          if (loginProgress == MinecraftAuthProgress.waitingForUserLogin &&
              authFlow == MicrosoftAuthFlow.authCode)
            BlocSelector<MicrosoftAuthCubit, MicrosoftAuthState, String>(
              selector: (state) => state.authCodeLoginUrlOrThrow,
              builder: (context, authCodeLoginUrl) {
                return GestureDetector(
                  onTap: () => launchUrl(Uri.parse(authCodeLoginUrl)),
                  onLongPress: () =>
                      Clipboard.setData(ClipboardData(text: authCodeLoginUrl)),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text(
                      message,
                      style: context.theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            )
          else
            Text(
              message,
              style: context.theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

class _SecureStorageUnsupportedWarning extends StatelessWidget {
  const _SecureStorageUnsupportedWarning();

  @override
  Widget build(BuildContext context) => AlertCard(
    type: AlertType.danger,
    title: context.loc.securityWarning,
    subtitle: context.loc.secureStorageUnsupportedWarning,
  );
}

/// Listens for Microsoft login result and shows messages accordingly.
///
/// Also closes the dialog on success or failure.
///
/// The [LoginWithMicrosoftDialog] is currently not closable
/// to ensure the [BlocListener] of this widget
/// can reliably respond to the login result since it lives inside the dialog.
class _MicrosoftLoginListener extends StatelessWidget {
  const _MicrosoftLoginListener({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MicrosoftAuthCubit, MicrosoftAuthState>(
      listenWhen: (previous, current) =>
          previous.loginStatus != current.loginStatus,
      listener: _onLoginStatusChanged,
      child: child,
    );
  }

  void _onLoginStatusChanged(BuildContext context, MicrosoftAuthState state) {
    switch (state.loginStatus) {
      case MicrosoftLoginStatus.successAddedNew:
      case MicrosoftLoginStatus.successRefreshedExisting:
        final username = state.recentAccountOrThrow.username;
        context.scaffoldMessenger.showSnackBarText(
          state.loginStatus == MicrosoftLoginStatus.successAddedNew
              ? context.loc.loginSuccessAccountAddedMessage(username)
              : context.loc.loginSuccessAccountUpdatedMessage(username),
        );
        context.pop();
        return;
      case MicrosoftLoginStatus.failure:
        final exception = state.exceptionOrThrow;
        final message = exception.getUserMessage(context.loc);
        final scaffoldMessenger = context.scaffoldMessenger;

        context.pop();

        // Handles special failures
        switch (exception) {
          case minecraft_account_service_exceptions.MicrosoftAuthApiException():
            final microsoftAuthApiException = exception.exception;
            switch (microsoftAuthApiException) {
              case microsoft_auth_api_exceptions.XstsErrorException():
                switch (microsoftAuthApiException.xstsError) {
                  case microsoft_auth_api_exceptions
                      .XstsError
                      .accountCreationRequired:
                    scaffoldMessenger.showSnackBarText(
                      message,
                      snackBarAction: SnackBarAction(
                        label: context.loc.createXboxAccount,
                        onPressed: () => launchUrl(
                          Uri.parse(MicrosoftConstants.createXboxAccountLink),
                        ),
                      ),
                    );
                    return;

                  case _:
                    scaffoldMessenger.showSnackBarText(message);
                    return;
                }
              case _:
                scaffoldMessenger.showSnackBarText(message);
                return;
            }

          case minecraft_account_service_exceptions.MinecraftAccountResolverException():
            switch (exception.exception) {
              case MinecraftJavaEntitlementAbsentException():
                showDialog<void>(
                  context: context,
                  builder: (context) =>
                      const MinecraftJavaEntitlementAbsentDialog(),
                );
            }
            return;

          case _:
            // Handles common failures
            scaffoldMessenger.showSnackBarText(message);
            return;
        }
      case _:
        // No action needed for other statuses
        return;
    }
  }
}
