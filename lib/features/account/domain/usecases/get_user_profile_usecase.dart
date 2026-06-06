import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/account/domain/entities/user_entity.dart';
import 'package:thimar/features/account/domain/repositories/account_repository.dart';

class GetUserProfileUseCase extends UseCase<UserEntity, NoParams> {
  final AccountRepository repository;

  GetUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return repository.getUserProfile();
  }
}
