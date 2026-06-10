part of 'client_orders_bloc.dart';

enum ClientOrdersStatus { initial, loading, success, failure }

enum ClientOrdersTab { current, finished }

class ClientOrdersState extends Equatable {
  final ClientOrdersStatus currentStatus;
  final ClientOrdersStatus finishedStatus;
  final ClientOrdersTab selectedTab;
  final List<OrderEntity> currentOrders;
  final List<OrderEntity> finishedOrders;
  final String? errorMessage;

  const ClientOrdersState({
    this.currentStatus = ClientOrdersStatus.initial,
    this.finishedStatus = ClientOrdersStatus.initial,
    this.selectedTab = ClientOrdersTab.current,
    this.currentOrders = const [],
    this.finishedOrders = const [],
    this.errorMessage,
  });

  ClientOrdersState copyWith({
    ClientOrdersStatus? currentStatus,
    ClientOrdersStatus? finishedStatus,
    ClientOrdersTab? selectedTab,
    List<OrderEntity>? currentOrders,
    List<OrderEntity>? finishedOrders,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ClientOrdersState(
      currentStatus: currentStatus ?? this.currentStatus,
      finishedStatus: finishedStatus ?? this.finishedStatus,
      selectedTab: selectedTab ?? this.selectedTab,
      currentOrders: currentOrders ?? this.currentOrders,
      finishedOrders: finishedOrders ?? this.finishedOrders,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    currentStatus,
    finishedStatus,
    selectedTab,
    currentOrders,
    finishedOrders,
    errorMessage,
  ];
}

abstract class ClientOrdersEvent extends Equatable {
  const ClientOrdersEvent();

  @override
  List<Object?> get props => [];
}

class ClientCurrentOrdersRequested extends ClientOrdersEvent {
  const ClientCurrentOrdersRequested();
}

class ClientFinishedOrdersRequested extends ClientOrdersEvent {
  const ClientFinishedOrdersRequested();
}

class ClientOrdersTabChanged extends ClientOrdersEvent {
  final ClientOrdersTab tab;

  const ClientOrdersTabChanged(this.tab);

  @override
  List<Object?> get props => [tab];
}
