import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

class CancelOrderDialog extends StatelessWidget {
  const CancelOrderDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const CancelOrderDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('cancel_order_confirmation'.tr()),
      content: Text('cancel_order_message'.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('no'.tr()),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // Handle order cancellation
          },
          child: Text('yes'.tr()),
        ),
      ],
    );
  }
}
