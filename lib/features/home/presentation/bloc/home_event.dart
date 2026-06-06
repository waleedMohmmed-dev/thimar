import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class ProductsFetched extends HomeEvent {
  const ProductsFetched();

  @override
  List<Object?> get props => [];
}

class ProductFavoriteToggled extends HomeEvent {
  final String productId;

  const ProductFavoriteToggled(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ProductsSearched extends HomeEvent {
  final String keyword;

  const ProductsSearched(this.keyword);

  @override
  List<Object?> get props => [keyword];
}
