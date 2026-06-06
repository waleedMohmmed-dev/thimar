import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_state.dart';
import 'package:thimar/features/auth/presentation/widgets/auth_widgets.dart';

class NewPasswordPage extends StatelessWidget {
  final String phoneNumber;
  final String otp;

  const NewPasswordPage({
    super.key,
    required this.phoneNumber,
    required this.otp,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: _NewPasswordView(phoneNumber: phoneNumber, otp: otp),
    );
  }
}

class _NewPasswordView extends StatefulWidget {
  final String phoneNumber;
  final String otp;

  const _NewPasswordView({required this.phoneNumber, required this.otp});

  @override
  State<_NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<_NewPasswordView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            context.goLogin('user');
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
                          subtitle: 'أدخل كلمة المرور الجديدة',
                          align: TextAlign.start,
                        ),
                        SizedBox(height: 32.h),
                        PasswordField(controller: _passwordController),
                        SizedBox(height: 16.h),
                        ConfirmPasswordField(
                          controller: _confirmPasswordController,
                          passwordController: _passwordController,
                        ),
                        SizedBox(height: 32.h),
                        ChangePasswordButton(
                          formKey: _formKey,
                          phoneNumber: widget.phoneNumber,
                          otp: widget.otp,
                          passwordController: _passwordController,
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
