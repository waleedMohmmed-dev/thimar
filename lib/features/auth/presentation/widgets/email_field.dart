import 'package:thimar/core/imports/core_imports.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: 'البريد الالكتروني',
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.mail_outline_rounded,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'البريد الالكتروني لا يمكن أن يكون فارغاً';
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(val)) {
          return 'يرجى إدخال بريد إلكتروني صحيح';
        }
        return null;
      },
    );
  }
}
