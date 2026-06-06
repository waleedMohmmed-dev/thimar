import 'package:thimar/core/imports/core_imports.dart';

class VehicleTypeField extends StatelessWidget {
  final TextEditingController controller;

  const VehicleTypeField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: 'نوع السيارة',
      keyboardType: TextInputType.text,
      prefixIcon: Icons.directions_car_outlined,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'نوع السيارة لا يمكن أن يكون فارغاً';
        }
        return null;
      },
    );
  }
}
