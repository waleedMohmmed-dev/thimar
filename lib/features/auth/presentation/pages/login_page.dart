import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_state.dart';
import 'package:thimar/features/auth/presentation/widgets/auth_widgets.dart';

class LoginPage extends StatelessWidget {
  final String userType;
  const LoginPage({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return _LoginView(userType: userType);
  }
}

class _LoginView extends StatefulWidget {
  final String userType;
  const _LoginView({required this.userType});

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  String _selectedCountryCode = '+966';

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
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
            context.goHome();
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
                          title: 'مرحبا بك مرة أخرى',
                          subtitle: 'يمكنك تسجيل الدخول الآن',
                        ),
                        SizedBox(height: 32.h),
                        PhoneField(
                          controller: _phoneController,
                          selectedCountryCode: _selectedCountryCode,
                          onCountryCodeChanged: (val) =>
                              setState(() => _selectedCountryCode = val),
                        ),
                        SizedBox(height: 16.h),
                        PasswordField(controller: _passwordController),
                        SizedBox(height: 12.h),
                        ForgotPasswordLink(
                          onTap: () => context.goForgotPassword(),
                        ),
                        SizedBox(height: 24.h),
                        LoginButton(
                          formKey: _formKey,
                          phoneController: _phoneController,
                          passwordController: _passwordController,
                          userType: widget.userType,
                        ),
                      ],
                    ),
                  ),
                ),
                AuthActionRow(
                  label: ' ليس لديك حساب ؟',
                  actionLabel: 'تسجيل كـ سائق',
                  onActionTap: () => context.goDriverRegistration(),
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