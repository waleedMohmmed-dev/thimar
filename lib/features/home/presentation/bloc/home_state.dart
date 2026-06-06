import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/home/domain/entities/product_entity.dart';

class HomeState extends Equatable {
  final List<ProductEntity> products;
  final bool isLoading;
  final String? errorMessage;
  final Set<String> favoriteIds;
  final List<ProductEntity> searchResults;
  final bool isSearching;
  final String? searchError;

  const HomeState({
    this.products = const [],
    this.isLoading = false,
    this.errorMessage,
    this.favoriteIds = const {},
    this.searchResults = const [],
    this.isSearching = false,
    this.searchError,
  });

  HomeState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    String? errorMessage,
    Set<String>? favoriteIds,
    List<ProductEntity>? searchResults,
    bool? isSearching,
    String? searchError,
  }) {
    return HomeState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      searchError: searchError ?? this.searchError,
    );
  }

  @override
  List<Object?> get props => [
        products,
        isLoading,
        errorMessage,
        favoriteIds,
        searchResults,
        isSearching,
        searchError,
      ];
}
