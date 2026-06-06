import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/auth/domain/repositories/auth_repository.dart';

class ResendCodeUseCase extends UseCase<void, ResendCodeParams> {
  final AuthRepository repository;

  ResendCodeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ResendCodeParams params) async {
    return await repository.resendCode(phone: params.phone);
  }
}

class ResendCodeParams extends Equatable {
  final String phone;

  const ResendCodeParams({required this.phone});

  @override
  List<Object?> get props => [phone];
}
