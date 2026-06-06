import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/models/user_role.dart';
import 'package:thimar/features/home/domain/usecases/get_products_use_case.dart';
import 'package:thimar/features/home/domain/usecases/search_products_use_case.dart';
import 'package:thimar/features/home/presentation/bloc/home_event.dart';
import 'package:thimar/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetProductsUseCase _getProductsUseCase;
  final SearchProductsUseCase _searchProductsUseCase;
  final UserRole _role;

  HomeBloc({
    required GetProductsUseCase getProductsUseCase,
    required SearchProductsUseCase searchProductsUseCase,
    required UserRole role,
  }) : _getProductsUseCase = getProductsUseCase,
       _searchProductsUseCase = searchProductsUseCase,
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
    // Driver does NOT fetch products - they only see pending orders
    if (_isDriver) {
      emit(state.copyWith(isLoading: false, products: []));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _getProductsUseCase(const NoParams());

    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (products) => emit(state.copyWith(isLoading: false, products: products)),
    );
  }

  void _onProductFavoriteToggled(
    ProductFavoriteToggled event,
    Emitter<HomeState> emit,
  ) {
    final updated = Set<String>.from(state.favoriteIds);
    if (updated.contains(event.productId)) {
      updated.remove(event.productId);
    } else {
      updated.add(event.productId);
    }
    emit(state.copyWith(favoriteIds: updated));
  }

  Future<void> _onProductsSearched(
    ProductsSearched event,
    Emitter<HomeState> emit,
  ) async {
    // Driver does NOT search products
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
