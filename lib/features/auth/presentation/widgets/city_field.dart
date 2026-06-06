import 'package:thimar/core/imports/core_imports.dart';

class CityField extends StatelessWidget {
  final TextEditingController controller;

  const CityField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: 'المدينة',
      keyboardType: TextInputType.text,
      prefixIcon: Icons.location_on_outlined,
      validator: (val) {
        if (val == null || val.isEmpty) return 'المدينة لا يمكن أن تكون فارغة';
        return null;
      },
    );
  }
}
