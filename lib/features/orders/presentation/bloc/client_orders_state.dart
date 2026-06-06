part of 'client_orders_bloc.dart';

enum ClientOrdersStatus { initial, loading, success, failure }

class ClientOrdersState extends Equatable {
  final ClientOrdersStatus status;
  final List<OrderEntity> orders;
  final String? errorMessage;

  const ClientOrdersState({
    this.status = ClientOrdersStatus.initial,
    this.orders = const [],
    this.errorMessage,
  });

  ClientOrdersState copyWith({
    ClientOrdersStatus? status,
    List<OrderEntity>? orders,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ClientOrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, orders, errorMessage];
}

abstract class ClientOrdersEvent extends Equatable {
  const ClientOrdersEvent();

  @override
  List<Object?> get props => [];
}

class ClientOrdersStarted extends ClientOrdersEvent {
  const ClientOrdersStarted();
}
