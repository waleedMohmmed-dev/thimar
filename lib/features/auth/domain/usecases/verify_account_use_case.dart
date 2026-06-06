import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/auth/domain/repositories/auth_repository.dart';

class VerifyAccountUseCase extends UseCase<void, VerifyAccountParams> {
  final AuthRepository repository;

  VerifyAccountUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(VerifyAccountParams params) async {
    return await repository.verifyAccount(
      code: params.code,
      phone: params.phone,
    );
  }
}

class VerifyAccountParams extends Equatable {
  final String code;
  final String phone;

  const VerifyAccountParams({
    required this.code,
    required this.phone,
  });

  @override
  List<Object?> get props => [code, phone];
}
