import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase extends UseCase<void, ForgotPasswordParams> {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    return await repository.forgotPassword(phone: params.phone);
  }
}

class ForgotPasswordParams extends Equatable {
  final String phone;

  const ForgotPasswordParams({required this.phone});

  @override
  List<Object?> get props => [phone];
}
