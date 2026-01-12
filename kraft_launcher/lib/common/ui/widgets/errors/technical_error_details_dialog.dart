import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kraft_launcher/common/ui/utils/build_context_ext.dart';
import 'package:kraft_launcher/common/ui/widgets/copy_code_block.dart';

/// Dialog to show technical details for unclear or expected errors
///
/// This is not meant for bugs or unexpected errors; the app should always avoid
/// handling these.
class TechnicalErrorDetailsDialog extends StatelessWidget {
  const TechnicalErrorDetailsDialog({super.key, required this.details});

  final String details;

  static void show(BuildContext context, {required String details}) =>
      showDialog<void>(
        context: context,
        builder: (context) => TechnicalErrorDetailsDialog(details: details),
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.loc.technicalErrorDetailsDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              // TODO(https://github.com/KraftLauncher/kraft-launcher/issues/15): IMPORTANT_TO_FIX This message is useless, either get rid of it OR
              //  provide something that's useful, test this dialog in action and make
              //  any changes if needed.
              'This dialog shows the technical details of the error for debugging or reporting purposes.',
              style: TextStyle(fontSize: 14),
            ),
          ),
          CopyCodeBlock(code: details),
        ],
      ),
      actions: [
        TextButton(onPressed: context.pop, child: Text(context.loc.close)),
      ],
    );
  }
}
