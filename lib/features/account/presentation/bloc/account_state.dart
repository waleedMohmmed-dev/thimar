import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/account/domain/entities/user_entity.dart';

class AccountState extends Equatable {
  final AccountStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const AccountState({
    this.status = AccountStatus.initial,
    this.user,
    this.errorMessage,
  });

  AccountState copyWith({
    AccountStatus? status,
    UserEntity? user,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AccountState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}

enum AccountStatus { initial, loading, success, failure, logoutSuccess }
