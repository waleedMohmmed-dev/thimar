import 'package:thimar/core/imports/core_imports.dart';

class ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;

  const ConfirmPasswordField({
    super.key,
    required this.controller,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: 'تأكيد كلمة المرور',
      isPassword: true,
      prefixIcon: Icons.lock_outline_rounded,
      validator: (val) {
        if (val == null || val.isEmpty) return 'تأكيد كلمة المرور لا يمكن أن يكون فارغاً';
        if (val != passwordController.text) return 'كلمات المرور غير متطابقة';
        return null;
      },
    );
  }
}
