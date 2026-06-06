import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/home/domain/entities/product_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String keyword);
}
