import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/about_app/domain/entities/about_app_entity.dart';

abstract class AboutAppRepository {
  Future<Either<Failure, AboutAppEntity>> getAbout();
}
