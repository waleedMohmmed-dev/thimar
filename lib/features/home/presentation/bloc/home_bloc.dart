import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/models/user_role.dart';
import 'package:thimar/features/home/domain/entities/product_entity.dart';
import 'package:thimar/features/home/domain/usecases/get_favorite_ids_use_case.dart';
import 'package:thimar/features/home/domain/usecases/get_products_use_case.dart';
import 'package:thimar/features/home/domain/usecases/get_sliders_use_case.dart';
import 'package:thimar/features/home/domain/usecases/search_products_use_case.dart';
import 'package:thimar/features/home/domain/usecases/toggle_favorite_use_case.dart';
import 'package:thimar/features/home/presentation/bloc/home_event.dart';
import 'package:thimar/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetProductsUseCase _getProductsUseCase;
  final SearchProductsUseCase _searchProductsUseCase;
  final GetSlidersUseCase _getSlidersUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;
  final GetFavoriteIdsUseCase _getFavoriteIdsUseCase;
  final UserRole _role;

  HomeBloc({
    required GetProductsUseCase getProductsUseCase,
    required SearchProductsUseCase searchProductsUseCase,
    required GetSlidersUseCase getSlidersUseCase,
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
    required GetFavoriteIdsUseCase getFavoriteIdsUseCase,
    required UserRole role,
  }) : _getProductsUseCase = getProductsUseCase,
       _searchProductsUseCase = searchProductsUseCase,
       _getSlidersUseCase = getSlidersUseCase,
       _toggleFavoriteUseCase = toggleFavoriteUseCase,
       _getFavoriteIdsUseCase = getFavoriteIdsUseCase,
       _role = role,
       super(const HomeState()) {
    on<ProductsFetched>(_onProductsFetched);
    on<ProductFavoriteToggled>(_onProductFavoriteToggled);
    on<ProductsSearched>(_onProductsSearched);
  }

  bool get _isDriver => _role == UserRole.driver;

  Future<void> _onProductsFetched(
    ProductsFetched event,
    Emitter<HomeState> emit,
  ) async {
    if (_isDriver) {
      emit(state.copyWith(isLoading: false, products: [], banners: []));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final results = await Future.wait([
      _getProductsUseCase(const NoParams()),
      _getSlidersUseCase(const NoParams()),
      _getFavoriteIdsUseCase(const NoParams()),
    ]);

    if (isClosed) return;

    final productsResult = results[0] as Either<Failure, List<ProductEntity>>;
    final slidersResult = results[1] as Either<Failure, List<String>>;
    final favoritesResult = results[2] as Either<Failure, Set<String>>;

    String? errorMessage;
    List<ProductEntity> products = [];
    List<String> banners = [];
    Set<String> favoriteIds = {};

    productsResult.fold(
      (failure) => errorMessage = failure.message,
      (data) => products = data,
    );
    slidersResult.fold((failure) => null, (data) => banners = data);
    favoritesResult.fold((failure) => null, (data) => favoriteIds = data);

    emit(
      state.copyWith(
        isLoading: false,
        products: products,
        banners: banners,
        favoriteIds: favoriteIds,
        errorMessage: errorMessage,
      ),
    );
  }

  Future<void> _onProductFavoriteToggled(
    ProductFavoriteToggled event,
    Emitter<HomeState> emit,
  ) async {
    final wasFavorite = state.favoriteIds.contains(event.productId);
    final updated = Set<String>.from(state.favoriteIds);
    if (wasFavorite) {
      updated.remove(event.productId);
    } else {
      updated.add(event.productId);
    }
    emit(state.copyWith(favoriteIds: updated));

    final result = await _toggleFavoriteUseCase(event.productId, !wasFavorite);
    if (isClosed) return;
    result.fold((failure) {
      final reverted = Set<String>.from(state.favoriteIds);
      if (wasFavorite) {
        reverted.add(event.productId);
      } else {
        reverted.remove(event.productId);
      }
      emit(state.copyWith(favoriteIds: reverted));
    }, (_) {});
  }

  Future<void> _onProductsSearched(
    ProductsSearched event,
    Emitter<HomeState> emit,
  ) async {
    if (_isDriver) {
      emit(state.copyWith(searchResults: [], isSearching: false));
      return;
    }

    if (event.keyword.trim().isEmpty) {
      emit(
        state.copyWith(
          searchResults: [],
          isSearching: false,
          searchError: null,
        ),
      );
      return;
    }

    emit(state.copyWith(isSearching: true, searchError: null));

    final result = await _searchProductsUseCase(event.keyword);

    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(isSearching: false, searchError: failure.message),
      ),
      (products) =>
          emit(state.copyWith(isSearching: false, searchResults: products)),
    );
  }
}
