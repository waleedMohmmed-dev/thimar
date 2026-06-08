import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/entities/product_entity.dart';
import 'package:thimar/features/home/domain/entities/rate_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String keyword);
  Future<Either<Failure, List<String>>> getSliders();
  Future<Either<Failure, Set<String>>> getFavoriteIds();
  Future<Either<Failure, List<ProductEntity>>> getFavoriteProducts();
  Future<Either<Failure, ProductEntity>> getProductById(String id);
  Future<Either<Failure, void>> toggleFavorite(String productId, bool isAdding);
  Future<Either<Failure, List<RateEntity>>> getProductRates(String productId);
  Future<Either<Failure, void>> addProductRate(
    String productId,
    int value,
    String comment,
  );
}
