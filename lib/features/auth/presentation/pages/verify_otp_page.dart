import 'dart:async';
import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_event.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_state.dart';
import 'package:thimar/features/auth/presentation/widgets/auth_widgets.dart';

enum VerifyPurpose { registration, forgotPassword }

class VerifyOtpPage extends StatelessWidget {
  final String phoneNumber;
  final VerifyPurpose purpose;

  const VerifyOtpPage({
    super.key,
    required this.phoneNumber,
    this.purpose = VerifyPurpose.registration,
  });

  @override
  Widget build(BuildContext context) {
    return _VerifyOtpView(phoneNumber: phoneNumber, purpose: purpose);
  }
}

class _VerifyOtpView extends StatefulWidget {
  final String phoneNumber;
  final VerifyPurpose purpose;

  const _VerifyOtpView({required this.phoneNumber, required this.purpose});

  @override
  State<_VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<_VerifyOtpView> {
  final List<TextEditingController> _otpControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  late Timer _timer;
  int _remainingSeconds = 120;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _canResend = true;
          _timer.cancel();
        }
      });
    });
  }

  void _resendOtp() {
    setState(() {
      _remainingSeconds = 120;
      _canResend = false;
      for (var controller in _otpControllers) {
        controller.clear();
      }
    });
    _startTimer();
    context.read<AuthBloc>().add(
      ResendCodeSubmitted(phone: widget.phoneNumber),
    );
  }

  String _getOtp() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
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
            if (state.successMessage != 'تم إعادة إرسال الكود بنجاح') {
              context.goLogin('user');

            }
          }
          if (state.errorMessage != null) {
            context.showErrorSnackBar(state.errorMessage!);
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 24.h),
                      const OtpLogo(),
                      SizedBox(height: 24.h),
                      const OtpHeader(),
                      SizedBox(height: 32.h),
                      PhoneDisplay(
                        phoneNumber: widget.phoneNumber,
                        onChangePhone: () => context.goForgotPassword(),
                      ),
                      SizedBox(height: 24.h),
                      OtpInputRow(
                        controllers: _otpControllers,
                        focusNodes: _focusNodes,
                      ),
                      SizedBox(height: 60.h),
                      OtpConfirmButton(
                        getOtp: _getOtp,
                        phoneNumber: widget.phoneNumber,
                        purpose: widget.purpose,
                      ),
                      SizedBox(height: 24.h),
                      ResendTimerSection(
                        remainingSeconds: _remainingSeconds,
                        canResend: _canResend,
                        onResend: _resendOtp,
                        formatTime: _formatTime,
                      ),
                    ],
                  ),
                ),
              ),
              OtpBottomLink(onLoginTap: () => context.goLogin('user')),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
