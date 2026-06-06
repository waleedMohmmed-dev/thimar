import 'package:thimar/core/imports/core_imports.dart';

class UsernameField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;

  const UsernameField({super.key, required this.controller, this.label});

  @override
  Widget build(BuildContext context) {
    final displayLabel = label ?? 'اسم المندوب';
    return AppTextField(
      controller: controller,
      hintText: displayLabel,
      keyboardType: TextInputType.text,
      prefixIcon: Icons.person_outline_rounded,
      validator: (val) {
        if (val == null || val.isEmpty) return '$displayLabel لا يمكن أن يكون فارغاً';
        if (val.length < 3) return 'يجب أن يكون الاسم 3 أحرف على الأقل';
        return null;
      },
    );
  }
}
