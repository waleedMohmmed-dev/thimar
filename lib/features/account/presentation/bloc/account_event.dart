import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/account/domain/entities/user_entity.dart';
import 'package:thimar/features/account/domain/usecases/update_driver_profile_use_case.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class AccountStarted extends AccountEvent {
  const AccountStarted();
}

class AccountLogoutRequested extends AccountEvent {
  const AccountLogoutRequested();
}

class AccountRefreshRequested extends AccountEvent {
  const AccountRefreshRequested();
}

class AccountProfileImagePicked extends AccountEvent {
  final String imagePath;

  const AccountProfileImagePicked({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

class AccountProfileUpdated extends AccountEvent {
  final UserEntity user;

  const AccountProfileUpdated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AccountDriverProfileUpdated extends AccountEvent {
  final DriverProfileParams params;

  const AccountDriverProfileUpdated({required this.params});

  @override
  List<Object?> get props => [params];
}
