import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';
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
      lat: params.lat,
      lng: params.lng,
    );
  }
}

class LoginParams extends Equatable {
  final String phone;
  final String password;
  final double lat;
  final double lng;

  const LoginParams({
    required this.phone,
    required this.password,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [phone, password, lat, lng];
}
