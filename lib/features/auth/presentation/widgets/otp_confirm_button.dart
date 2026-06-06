import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_event.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_state.dart';
import 'package:thimar/features/auth/presentation/pages/verify_otp_page.dart';

class OtpConfirmButton extends StatelessWidget {
  final String Function() getOtp;
  final String phoneNumber;
  final VerifyPurpose purpose;

  const OtpConfirmButton({
    super.key,
    required this.getOtp,
    required this.phoneNumber,
    this.purpose = VerifyPurpose.registration,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthBloc, AuthState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, isLoading) {
        return AppButton(
          label: 'تأكيد الكود',
          size: ButtonSize.large,
          onPressed: () {
            final otp = getOtp();
            if (otp.length == 4) {
              if (purpose == VerifyPurpose.forgotPassword) {
                context.go('${AppRoutes.newPassword}/$phoneNumber/$otp');
              } else {
                context.read<AuthBloc>().add(
                  VerifyOtpSubmitted(
                    code: otp,
                    phone: phoneNumber,
                  ),
                );
              }
            } else {
              context.showErrorSnackBar('الكود غير صحيح');
            }
          },
          isLoading: isLoading,
        );
      },
    );
  }
}
