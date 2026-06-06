import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/auth/domain/entities/user_entity.dart';
import 'package:thimar/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return repository.login(
      phone: params.phone,
      password: params.password,
      userType: params.userType,
      lat: params.lat,
      lng: params.lng,
    );
  }
}

class LoginParams extends Equatable {
  final String phone;
  final String password;
  final String userType;
  final double lat;
  final double lng;

  const LoginParams({
    required this.phone,
    required this.password,
    required this.userType,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [phone, password, userType, lat, lng];
}
