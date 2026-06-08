import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/entities/product_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String keyword);
  Future<Either<Failure, List<String>>> getSliders();
  Future<Either<Failure, Set<String>>> getFavoriteIds();
  Future<Either<Failure, List<ProductEntity>>> getFavoriteProducts();
  Future<Either<Failure, void>> toggleFavorite(String productId, bool isAdding);
}
