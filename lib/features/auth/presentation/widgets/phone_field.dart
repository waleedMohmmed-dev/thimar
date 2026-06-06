import 'package:thimar/core/imports/core_imports.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String selectedCountryCode;
  final ValueChanged<String> onCountryCodeChanged;

  const PhoneField({
    super.key,
    required this.controller,
    required this.selectedCountryCode,
    required this.onCountryCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: AppTextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            hintText: 'رقم الجوال',
            hintTextDirection: TextDirection.rtl,
            prefixIcon: Icons.phone_outlined,
            validator: (val) {
              if (val == null || val.isEmpty) return 'رقم الجوال لا يمكن أن يكون فارغاً';
              if (val.length < 9) return 'رقم الجوال غير صحيح';
              return null;
            },
          ),
        ),
        SizedBox(width: 8.w),
        AppCountryCodes(
          value: selectedCountryCode,
          onChanged: onCountryCodeChanged,
        ),
      ],
    );
  }
}
