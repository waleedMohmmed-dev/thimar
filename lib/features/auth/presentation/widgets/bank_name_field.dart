import 'package:thimar/core/imports/core_imports.dart';

class BankNameField extends StatelessWidget {
  final TextEditingController controller;

  const BankNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: 'اسم البنك',
      keyboardType: TextInputType.text,
      prefixIcon: Icons.account_balance_outlined,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'اسم البنك لا يمكن أن يكون فارغاً';
        }
        return null;
      },
    );
  }
}
