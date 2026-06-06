import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/privacy/domain/entities/privacy_entity.dart';

abstract class PrivacyRepository {
  Future<Either<Failure, PrivacyEntity>> getPrivacy();
}
