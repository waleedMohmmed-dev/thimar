import 'package:thimar/core/imports/core_imports.dart';

class LocationPickerField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onTap;

  const LocationPickerField({
    super.key,
    required this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: AppTextField(
          controller: controller,
          hintText: 'تحديد الموقع على الخريطة',
          readOnly: true,
          prefixIcon: Icons.location_on_outlined,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'يرجى تحديد الموقع على الخريطة';
            }
            return null;
          },
        ),
      ),
    );
  }
}
