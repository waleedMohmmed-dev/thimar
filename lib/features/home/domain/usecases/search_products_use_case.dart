import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/entities/product_entity.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';

class SearchProductsUseCase
    implements UseCase<List<ProductEntity>, SearchProductsParams> {
  final HomeRepository repository;

  SearchProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    SearchProductsParams params,
  ) {
    return repository.searchProducts(
      keyword: params.keyword,
      filter: params.filter,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
    );
  }
}

class SearchProductsParams extends Equatable {
  final String keyword;
  final String? filter;
  final double? minPrice;
  final double? maxPrice;

  const SearchProductsParams({
    required this.keyword,
    this.filter,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [keyword, filter, minPrice, maxPrice];
}
