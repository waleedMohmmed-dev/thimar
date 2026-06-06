import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/usecases/usecase.dart';
import 'package:thimar/features/faq/domain/entities/faq_entity.dart';
import 'package:thimar/features/faq/domain/repositories/faq_repository.dart';

class GetFaqsUseCase extends UseCase<List<FaqEntity>, NoParams> {
  final FaqRepository repository;

  GetFaqsUseCase(this.repository);

  @override
  Future<Either<Failure, List<FaqEntity>>> call(NoParams params) async {
    return await repository.getFaqs();
  }
}
