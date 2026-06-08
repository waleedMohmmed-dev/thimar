import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/entities/category_entity.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';

class GetCategoriesUseCase
    implements UseCase<List<CategoryEntity>, NoParams> {
  final HomeRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) async {
    return repository.getCategories();
  }
}
