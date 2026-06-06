import 'package:thimar/core/imports/core_imports.dart';

class IdentityNumberField extends StatelessWidget {
  final TextEditingController controller;

  const IdentityNumberField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: 'رقم الهوية',
      keyboardType: TextInputType.number,
      prefixIcon: Icons.badge_outlined,
      maxLength: 10,
      counterText: '',
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'رقم الهوية لا يمكن أن يكون فارغاً';
        }
        if (val.length != 10) {
          return 'رقم الهوية يجب أن يكون 10 أرقام';
        }
        return null;
      },
    );
  }
}
