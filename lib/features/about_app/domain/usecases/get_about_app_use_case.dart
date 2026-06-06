import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/usecases/usecase.dart';
import 'package:thimar/features/about_app/domain/entities/about_app_entity.dart';
import 'package:thimar/features/about_app/domain/repositories/about_app_repository.dart';

class GetAboutAppUseCase extends UseCase<AboutAppEntity, NoParams> {
  final AboutAppRepository repository;

  GetAboutAppUseCase(this.repository);

  @override
  Future<Either<Failure, AboutAppEntity>> call(NoParams params) async {
    return await repository.getAbout();
  }
}
