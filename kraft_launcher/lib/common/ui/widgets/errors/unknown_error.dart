import 'package:flutter/material.dart';
import 'package:kraft_launcher/common/constants/constants.dart';
import 'package:kraft_launcher/common/generated/assets.gen.dart';
import 'package:kraft_launcher/common/ui/utils/build_context_ext.dart';
import 'package:kraft_launcher/common/ui/utils/exception_with_stacktrace.dart';
import 'package:kraft_launcher/common/ui/widgets/copy_code_block.dart';
import 'package:kraft_launcher/common/ui/widgets/info_text_with_lottie.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO: Probably invalid, is this for errors (bugs) or failures (expected)?

class UnknownError extends StatelessWidget {
  const UnknownError({
    required this.onTryAgain,
    super.key,
    required this.message,
    required this.exceptionWithStackTrace,
  });

  final VoidCallback? onTryAgain;
  final String message;
  final ExceptionWithStacktrace exceptionWithStackTrace;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: InfoTextWithLottie(
          title: context.loc.errorOccurred,
          subtitle: message,
          lottieAssetPath: Assets.lottie.errors.unknownError.path,
          spacingBetweenTitleAndSubtitle: 4,
          spacingBetweenSubtitleAndBellowSubtitle: 16,
          bellowSubtitle: Column(
            spacing: 20,
            children: [
              Row(
                spacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: onTryAgain,
                    label: Text(context.loc.tryAgain),
                    icon: const Icon(Icons.refresh),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        launchUrl(Uri.parse(Constants.reportBugLink)),
                    label: Text(context.loc.reportBug),
                    icon: const Icon(Icons.bug_report),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: CopyCodeBlock(
                    code: exceptionWithStackTrace.toString(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
