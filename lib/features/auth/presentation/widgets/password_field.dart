import 'package:thimar/core/imports/core_imports.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;

  const PasswordField({super.key, required this.controller, this.hintText});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText ?? 'كلمة المرور',
      isPassword: true,
      prefixIcon: Icons.lock_outline_rounded,
      validator: (val) {
        if (val == null || val.isEmpty)
          return 'كلمة المرور لا يمكن أن تكون فارغة';
        if (val.length < 6)
          return 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';
        return null;
      },
    );
  }
}
