import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/auth/domain/usecases/login_use_case.dart';
import 'package:thimar/features/auth/domain/usecases/driver_register_use_case.dart';
import 'package:thimar/features/auth/domain/usecases/verify_account_use_case.dart';
import 'package:thimar/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:thimar/features/auth/domain/usecases/resend_code_use_case.dart';
import 'package:thimar/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_event.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final DriverRegisterUseCase _driverRegisterUseCase;
  final VerifyAccountUseCase _verifyAccountUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResendCodeUseCase _resendCodeUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required DriverRegisterUseCase driverRegisterUseCase,
    required VerifyAccountUseCase verifyAccountUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required ResendCodeUseCase resendCodeUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    dynamic registerUseCase, // Ignored client register
  })  : _loginUseCase = loginUseCase,
        _driverRegisterUseCase = driverRegisterUseCase,
        _verifyAccountUseCase = verifyAccountUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _resendCodeUseCase = resendCodeUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        super(const AuthState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<DriverRegisterSubmitted>(_onDriverRegisterSubmitted);
    on<VerifyOtpSubmitted>(_onVerifyOtpSubmitted);
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
    on<ResendCodeSubmitted>(_onResendCodeSubmitted);
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));

    final result = await _loginUseCase(
      LoginParams(
        phone: event.phone,
        password: event.password,
        lat: event.lat,
        lng: event.lng,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        isLoading: false,
        user: user,
        successMessage: 'login_success'.tr(),
      )),
    );
  }

  Future<void> _onDriverRegisterSubmitted(
    DriverRegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));

    final result = await _driverRegisterUseCase(
      DriverRegisterParams(
        name: event.name,
        email: event.email,
        phone: event.phone,
        cityId: event.cityId,
        password: event.password,
        identityNumber: event.identityNumber,
        lat: event.lat,
        lng: event.lng,
        locationDescription: event.locationDescription,
        vehicleType: event.vehicleType,
        modelId: event.modelId,
        iban: event.iban,
        bankName: event.bankName,
        driverLicensePath: event.driverLicensePath,
        vehicleRegistrationPath: event.vehicleRegistrationPath,
        vehicleInsurancePath: event.vehicleInsurancePath,
        vehicleFrontPath: event.vehicleFrontPath,
        vehicleRearPath: event.vehicleRearPath,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        isLoading: false,
        user: user,
        successMessage: 'register_success'.tr(),
      )),
    );
  }

  Future<void> _onVerifyOtpSubmitted(
    VerifyOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));

    final result = await _verifyAccountUseCase(
      VerifyAccountParams(
        code: event.code,
        phone: event.phone,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        isLoading: false,
        successMessage: 'تم التحقق بنجاح',
      )),
    );
  }

  Future<void> _onForgotPasswordSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));

    final result = await _forgotPasswordUseCase(
      ForgotPasswordParams(phone: event.phone),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        isLoading: false,
        successMessage: 'تم إرسال الكود بنجاح',
      )),
    );
  }

  Future<void> _onResendCodeSubmitted(
    ResendCodeSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));

    final result = await _resendCodeUseCase(
      ResendCodeParams(phone: event.phone),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        isLoading: false,
        successMessage: 'تم إعادة إرسال الكود بنجاح',
      )),
    );
  }

  Future<void> _onResetPasswordSubmitted(
    ResetPasswordSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));

    final result = await _resetPasswordUseCase(
      ResetPasswordParams(
        phone: event.phone,
        code: event.code,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        isLoading: false,
        successMessage: 'تم تغيير كلمة المرور بنجاح',
      )),
    );
  }
}
