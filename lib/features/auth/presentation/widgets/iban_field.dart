import 'package:thimar/core/imports/core_imports.dart';

class IbanField extends StatelessWidget {
  final TextEditingController controller;

  const IbanField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: 'IBAN',
      keyboardType: TextInputType.text,
      prefixIcon: Icons.account_balance_outlined,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'رقم الآيبان لا يمكن أن يكون فارغاً';
        }
        final cleaned = val.replaceAll(' ', '').toUpperCase();
        if (!cleaned.startsWith('SA')) {
          return 'رقم الآيبان يجب أن يبدأ بـ SA';
        }
        if (cleaned.length != 24) {
          return 'رقم الآيبان يجب أن يكون 24 حرفاً';
        }
        return null;
      },
    );
  }
}
