import 'package:thimar/core/imports/core_imports.dart';

class VehicleModelField extends StatelessWidget {
  final TextEditingController controller;

  const VehicleModelField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: 'موديل السيارة',
      keyboardType: TextInputType.text,
      prefixIcon: Icons.calendar_today_outlined,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'موديل السيارة لا يمكن أن يكون فارغاً';
        }
        return null;
      },
    );
  }
}
