import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase extends UseCase<void, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    return await repository.resetPassword(
      phone: params.phone,
      code: params.code,
      password: params.password,
    );
  }
}

class ResetPasswordParams extends Equatable {
  final String phone;
  final String code;
  final String password;

  const ResetPasswordParams({
    required this.phone,
    required this.code,
    required this.password,
  });

  @override
  List<Object?> get props => [phone, code, password];
}
