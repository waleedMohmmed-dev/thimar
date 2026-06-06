import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';

class OrdersState extends Equatable {
  final OrdersTab selectedTab;
  final OrdersStatus status;
  final List<OrderEntity> pendingOrders;
  final List<OrderEntity> currentOrders;
  final List<OrderEntity> finishedOrders;
  final String? errorMessage;
  final List<OrderEntity> searchResults;
  final bool isSearching;
  final String? searchError;
  final bool finishedHasMore;
  final int finishedCurrentPage;
  final bool isFinishedLoadingMore;
  final bool isRefusingOrder;
  final String? refuseError;
  final String? refuseSuccessMessage;

  const OrdersState({
    this.selectedTab = OrdersTab.current,
    this.status = OrdersStatus.initial,
    this.pendingOrders = const [],
    this.currentOrders = const [],
    this.finishedOrders = const [],
    this.errorMessage,
    this.searchResults = const [],
    this.isSearching = false,
    this.searchError,
    this.finishedHasMore = false,
    this.finishedCurrentPage = 1,
    this.isFinishedLoadingMore = false,
    this.isRefusingOrder = false,
    this.refuseError,
    this.refuseSuccessMessage,
  });

  OrdersState copyWith({
    OrdersTab? selectedTab,
    OrdersStatus? status,
    List<OrderEntity>? pendingOrders,
    List<OrderEntity>? currentOrders,
    List<OrderEntity>? finishedOrders,
    String? errorMessage,
    bool clearError = false,
    List<OrderEntity>? searchResults,
    bool? isSearching,
    String? searchError,
    bool clearSearchError = false,
    bool? finishedHasMore,
    int? finishedCurrentPage,
    bool clearFinishedPagination = false,
    bool? isFinishedLoadingMore,
    bool? isRefusingOrder,
    String? refuseError,
    bool clearRefuseError = false,
    String? refuseSuccessMessage,
    bool clearRefuseSuccess = false,
  }) {
    return OrdersState(
      selectedTab: selectedTab ?? this.selectedTab,
      status: status ?? this.status,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      currentOrders: currentOrders ?? this.currentOrders,
      finishedOrders: finishedOrders ?? this.finishedOrders,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      searchError: clearSearchError
          ? null
          : searchError ?? this.searchError,
      finishedHasMore: clearFinishedPagination
          ? false
          : finishedHasMore ?? this.finishedHasMore,
      finishedCurrentPage: clearFinishedPagination
          ? 1
          : finishedCurrentPage ?? this.finishedCurrentPage,
      isFinishedLoadingMore: isFinishedLoadingMore ?? this.isFinishedLoadingMore,
      isRefusingOrder: isRefusingOrder ?? this.isRefusingOrder,
      refuseError: clearRefuseError ? null : refuseError ?? this.refuseError,
      refuseSuccessMessage: clearRefuseSuccess
          ? null
          : refuseSuccessMessage ?? this.refuseSuccessMessage,
    );
  }

  @override
  List<Object?> get props => [
    selectedTab,
    status,
    pendingOrders,
    currentOrders,
    finishedOrders,
    errorMessage,
    searchResults,
    isSearching,
    searchError,
    finishedHasMore,
    finishedCurrentPage,
    isFinishedLoadingMore,
    isRefusingOrder,
    refuseError,
    refuseSuccessMessage,
  ];
}

enum OrdersStatus { initial, loading, success, failure }

enum OrdersTab { current, finished }

extension OrdersTabX on OrdersTab {
  int get pageIndex {
    return switch (this) {
      OrdersTab.current => 0,
      OrdersTab.finished => 1,
    };
  }

  String get labelKey {
    return switch (this) {
      OrdersTab.current => 'current_orders',
      OrdersTab.finished => 'finished_orders',
    };
  }
}
