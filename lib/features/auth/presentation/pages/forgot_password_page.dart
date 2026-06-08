import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_state.dart';
import 'package:thimar/features/auth/presentation/pages/verify_otp_page.dart';
import 'package:thimar/features/auth/presentation/widgets/auth_widgets.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  String _selectedCountryCode = '+966';

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, curr) =>
            prev.successMessage != curr.successMessage ||
            prev.errorMessage != curr.errorMessage,
        listener: (context, state) {
          if (state.successMessage != null) {
            context.showSnackBar(state.successMessage!);
            final phoneNumber =
                '$_selectedCountryCode${_phoneController.text.trim()}';
            context.goVerifyOtp(
              phoneNumber,
              purpose: VerifyPurpose.forgotPassword,
            );
          }
          if (state.errorMessage != null) {
            context.showErrorSnackBar(state.errorMessage!);
          }
        },
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 24.h),
                        const AuthLogo(),
                        SizedBox(height: 24.h),
                        const AuthHeader(
                          title: 'نسيت كلمة المرور',
                          subtitle: 'أدخل رقم الجوال المرتبط بحسابك',
                        ),
                        SizedBox(height: 32.h),
                        ForgotPasswordForm(
                          formKey: _formKey,
                          phoneController: _phoneController,
                          selectedCountryCode: _selectedCountryCode,
                          onCountryCodeChanged: (val) =>
                              setState(() => _selectedCountryCode = val),
                        ),
                      ],
                    ),
                  ),
                ),
                AuthActionRow(
                  label: ' لديك حساب بالفعل ؟',
                  actionLabel: 'تسجيل الدخول',
                  onActionTap: () => context.goLogin('user'),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
