import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_event.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_state.dart';

class ChangePasswordButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String phoneNumber;
  final String otp;
  final TextEditingController passwordController;

  const ChangePasswordButton({
    super.key,
    required this.formKey,
    required this.phoneNumber,
    required this.otp,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthBloc, AuthState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, isLoading) {
        return AppButton(
          label: 'تغيير كلمة المرور',
          size: ButtonSize.large,
          isLoading: isLoading,
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              context.read<AuthBloc>().add(
                ResetPasswordSubmitted(
                  phone: phoneNumber,
                  code: otp,
                  password: passwordController.text,
                ),
              );
            }
          },
        );
      },
    );
  }
}
