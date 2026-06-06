import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/auth/domain/entities/user_entity.dart';

class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  RegisterUseCase(dynamic repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return Left(ServerFailure('Client registration is disabled.'));
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String phone;
  final String gender;
  final double lat;
  final double lng;
  final String password;

  const RegisterParams({
    required this.name,
    required this.phone,
    required this.gender,
    required this.lat,
    required this.lng,
    required this.password,
  });

  @override
  List<Object?> get props => [name, phone, gender, lat, lng, password];
}
