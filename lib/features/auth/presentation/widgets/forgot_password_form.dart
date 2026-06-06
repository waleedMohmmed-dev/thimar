import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_event.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_state.dart';

class ForgotPasswordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final String selectedCountryCode;
  final ValueChanged<String> onCountryCodeChanged;

  const ForgotPasswordForm({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.selectedCountryCode,
    required this.onCountryCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: AppTextField(
                controller: phoneController,
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
        ),
        SizedBox(height: 32.h),
        _ConfirmPhoneButton(
          formKey: formKey,
          selectedCountryCode: selectedCountryCode,
          phoneController: phoneController,
        ),
      ],
    );
  }
}

class _ConfirmPhoneButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String selectedCountryCode;
  final TextEditingController phoneController;

  const _ConfirmPhoneButton({
    required this.formKey,
    required this.selectedCountryCode,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthBloc, AuthState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, isLoading) {
        return AppButton(
          label: 'تأكيد رقم الجوال',
          size: ButtonSize.large,
          isLoading: isLoading,
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              final phoneNumber = '$selectedCountryCode${phoneController.text.trim()}';
              context.read<AuthBloc>().add(
                ForgotPasswordSubmitted(phone: phoneNumber),
              );
            }
          },
        );
      },
    );
  }
}
