import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/usecases/get_pending_orders_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/get_current_orders_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/get_finished_orders_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/search_current_orders_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/search_finished_orders_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/refuse_order_use_case.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_event.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetPendingOrdersUseCase _getPendingOrdersUseCase;
  final GetCurrentOrdersUseCase _getCurrentOrdersUseCase;
  final GetFinishedOrdersUseCase _getFinishedOrdersUseCase;
  final SearchCurrentOrdersUseCase _searchCurrentOrdersUseCase;
  final SearchFinishedOrdersUseCase _searchFinishedOrdersUseCase;
  final RefuseOrderUseCase _refuseOrderUseCase;

  OrdersBloc({
    required GetPendingOrdersUseCase getPendingOrdersUseCase,
    required GetCurrentOrdersUseCase getCurrentOrdersUseCase,
    required GetFinishedOrdersUseCase getFinishedOrdersUseCase,
    required SearchCurrentOrdersUseCase searchCurrentOrdersUseCase,
    required SearchFinishedOrdersUseCase searchFinishedOrdersUseCase,
    required RefuseOrderUseCase refuseOrderUseCase,
  })  : _getPendingOrdersUseCase = getPendingOrdersUseCase,
        _getCurrentOrdersUseCase = getCurrentOrdersUseCase,
        _getFinishedOrdersUseCase = getFinishedOrdersUseCase,
        _searchCurrentOrdersUseCase = searchCurrentOrdersUseCase,
        _searchFinishedOrdersUseCase = searchFinishedOrdersUseCase,
        _refuseOrderUseCase = refuseOrderUseCase,
        super(const OrdersState()) {
    on<PendingOrdersRequested>(_onPendingOrdersRequested);
    on<CurrentOrdersRequested>(_onCurrentOrdersRequested);
    on<FinishedOrdersRequested>(_onFinishedOrdersRequested);
    on<OrdersTabChanged>(_onOrdersTabChanged);
    on<OrdersSearched>(_onOrdersSearched);
    on<FinishedOrdersLoadMore>(_onFinishedOrdersLoadMore);
    on<OrderRefused>(_onOrderRefused);
    on<OrderDeliveringStarted>(_onOrderDeliveringStarted);
    on<ClearDeliveringStartedMessage>(_onClearDeliveringStartedMessage);
    on<ClearHomeTabIndex>(_onClearHomeTabIndex);
  }

  Future<void> _onPendingOrdersRequested(
    PendingOrdersRequested event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.loading));
    final result = await _getPendingOrdersUseCase(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
          status: OrdersStatus.failure, errorMessage: failure.message)),
      (orders) => emit(state.copyWith(
          status: OrdersStatus.success, pendingOrders: orders)),
    );
  }

  Future<void> _onCurrentOrdersRequested(
    CurrentOrdersRequested event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.loading));
    final result = await _getCurrentOrdersUseCase(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
          status: OrdersStatus.failure, errorMessage: failure.message)),
      (orders) => emit(state.copyWith(
          status: OrdersStatus.success, currentOrders: orders)),
    );
  }

  Future<void> _onFinishedOrdersRequested(
    FinishedOrdersRequested event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.loading));
    final result = await _getFinishedOrdersUseCase(1);
    result.fold(
      (failure) => emit(state.copyWith(
          status: OrdersStatus.failure, errorMessage: failure.message)),
      (data) => emit(state.copyWith(
          status: OrdersStatus.success,
          finishedOrders: data.orders,
          finishedHasMore: data.hasMore,
          finishedCurrentPage: 1)),
    );
  }

  void _onOrdersTabChanged(OrdersTabChanged event, Emitter<OrdersState> emit) {
    if (event.tab == state.selectedTab) return;
    emit(state.copyWith(
      selectedTab: event.tab,
      searchResults: [],
      isSearching: false,
      clearSearchError: true,
    ));
  }

  Future<void> _onOrdersSearched(
    OrdersSearched event,
    Emitter<OrdersState> emit,
  ) async {
    final keyword = event.keyword.trim();
    if (keyword.isEmpty) {
      emit(state.copyWith(
        searchResults: [],
        isSearching: false,
        clearSearchError: true,
      ));
      return;
    }

    emit(state.copyWith(isSearching: true, clearSearchError: true));

    final result = state.selectedTab == OrdersTab.current
        ? await _searchCurrentOrdersUseCase(
            SearchCurrentOrdersParams(keyword: keyword),
          )
        : await _searchFinishedOrdersUseCase(
            SearchFinishedOrdersParams(keyword: keyword),
          );

    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          isSearching: false,
          searchError: failure.message,
        ),
      ),
      (orders) => emit(
        state.copyWith(
          isSearching: false,
          searchResults: orders,
        ),
      ),
    );
  }

  Future<void> _onFinishedOrdersLoadMore(
    FinishedOrdersLoadMore event,
    Emitter<OrdersState> emit,
  ) async {
    if (state.isFinishedLoadingMore || !state.finishedHasMore) return;

    final nextPage = state.finishedCurrentPage + 1;
    emit(state.copyWith(isFinishedLoadingMore: true));

    final result = await _getFinishedOrdersUseCase(nextPage);

    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(isFinishedLoadingMore: false)),
      (data) => emit(
        state.copyWith(
          isFinishedLoadingMore: false,
          finishedOrders: [...state.finishedOrders, ...data.orders],
          finishedHasMore: data.hasMore,
          finishedCurrentPage: nextPage,
        ),
      ),
    );
  }

  Future<void> _onOrderRefused(
    OrderRefused event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(
      isRefusingOrder: true,
      clearRefuseError: true,
      clearRefuseSuccess: true,
    ));

    final result = await _refuseOrderUseCase(event.orderId);

    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          isRefusingOrder: false,
          refuseError: failure.message,
        ),
      ),
      (message) {
        final updatedPendingOrders = state.pendingOrders
            .where((order) => order.id != event.orderId)
            .toList();
        final updatedSearchResults = state.searchResults
            .where((order) => order.id != event.orderId)
            .toList();

        emit(
          state.copyWith(
            isRefusingOrder: false,
            refuseSuccessMessage: message,
            pendingOrders: updatedPendingOrders,
            searchResults: updatedSearchResults,
          ),
        );
      },
    );
  }

  void _onOrderDeliveringStarted(
    OrderDeliveringStarted event,
    Emitter<OrdersState> emit,
  ) {
    final updatedOrder = event.order.copyWith(
      status: OrderStatus.onWay,
    );
    final pendingOrders = List<OrderEntity>.from(state.pendingOrders)
      ..removeWhere((o) => o.id == updatedOrder.id);
    final currentOrders = List<OrderEntity>.from(state.currentOrders);
    final idx = currentOrders.indexWhere((o) => o.id == updatedOrder.id);
    if (idx >= 0) {
      currentOrders[idx] = updatedOrder;
    } else {
      currentOrders.add(updatedOrder);
    }
    emit(state.copyWith(
      selectedTab: OrdersTab.current,
      pendingOrders: pendingOrders,
      currentOrders: currentOrders,
      deliveringStartedMessage: 'تم اضافة الطلب الى الطلبات الجارية',
      homeTabIndex: 1,
    ));
  }

  void _onClearDeliveringStartedMessage(
    ClearDeliveringStartedMessage event,
    Emitter<OrdersState> emit,
  ) {
    emit(state.copyWith(clearDeliveringStartedMessage: true));
  }

  void _onClearHomeTabIndex(
    ClearHomeTabIndex event,
    Emitter<OrdersState> emit,
  ) {
    emit(state.copyWith(clearHomeTabIndex: true));
  }
}
