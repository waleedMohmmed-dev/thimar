import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/entities/product_entity.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';

class GetCategoryProductsUseCase
    implements UseCase<List<ProductEntity>, int> {
  final HomeRepository repository;

  GetCategoryProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(int categoryId) async {
    return repository.getCategoryProducts(categoryId);
  }
}
