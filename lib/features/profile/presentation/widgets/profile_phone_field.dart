import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/profile/presentation/widgets/profile_widgets.dart';

class ProfilePhoneField extends StatelessWidget {
  final String selectedCountryCode;
  final ValueChanged<String> onCountryCodeChanged;

  const ProfilePhoneField({
    super.key,
    required this.selectedCountryCode,
    required this.onCountryCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: ProfileField(
            label: 'phone_number'.tr(),
            value: '',
            icon: Icons.phone_outlined,
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
