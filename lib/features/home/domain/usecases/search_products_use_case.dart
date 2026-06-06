import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/entities/product_entity.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';

class SearchProductsUseCase {
  final HomeRepository repository;

  SearchProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call(String keyword) {
    return repository.searchProducts(keyword);
  }
}
