import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/faq/domain/entities/faq_entity.dart';

abstract class FaqRepository {
  Future<Either<Failure, List<FaqEntity>>> getFaqs();
}
