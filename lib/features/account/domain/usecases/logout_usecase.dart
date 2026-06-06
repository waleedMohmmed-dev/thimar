import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/account/domain/repositories/account_repository.dart';

class LogoutUseCase extends UseCase<void, NoParams> {
  final AccountRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.logout();
  }
}
