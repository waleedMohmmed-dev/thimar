import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/models/user_role.dart';
import 'package:thimar/features/auth/domain/entities/user_entity.dart';

class AuthState extends Equatable {
  final UserEntity? user;
  final UserRole? role;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const AuthState({
    this.user,
    this.role,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  AuthState copyWith({
    UserEntity? user,
    UserRole? role,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      role: role ?? this.role,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess
          ? null
          : successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
    user,
    role,
    isLoading,
    errorMessage,
    successMessage,
  ];
}
