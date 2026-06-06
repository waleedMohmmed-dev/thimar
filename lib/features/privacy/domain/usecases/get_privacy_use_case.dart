import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/privacy/domain/entities/privacy_entity.dart';
import 'package:thimar/features/privacy/domain/repositories/privacy_repository.dart';

class GetPrivacyUseCase extends UseCase<PrivacyEntity, NoParams> {
  final PrivacyRepository repository;

  GetPrivacyUseCase(this.repository);

  @override
  Future<Either<Failure, PrivacyEntity>> call(NoParams params) async {
    return await repository.getPrivacy();
  }
}
