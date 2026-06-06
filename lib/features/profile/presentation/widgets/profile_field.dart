import 'package:thimar/core/imports/core_imports.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final String? hint;
  final bool obscure;

  const ProfileField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return AppTextField(
      controller: TextEditingController(text: value),
      labelText: label,
      hintText: obscure ? hint : null,
      suffixIcon: icon,
      isPassword: obscure,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      style: TextStyle(fontSize: 18.sp, color: cs.primary),
      fillColor: cs.surfaceContainerHighest,
    );
  }
}
