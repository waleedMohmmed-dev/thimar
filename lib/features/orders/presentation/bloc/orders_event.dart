import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_state.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class PendingOrdersRequested extends OrdersEvent {
  const PendingOrdersRequested();
}

class CurrentOrdersRequested extends OrdersEvent {
  const CurrentOrdersRequested();
}

class FinishedOrdersRequested extends OrdersEvent {
  const FinishedOrdersRequested();
}

class OrdersTabChanged extends OrdersEvent {
  final OrdersTab tab;

  const OrdersTabChanged(this.tab);

  @override
  List<Object?> get props => [tab];
}

class OrdersSearched extends OrdersEvent {
  final String keyword;

  const OrdersSearched(this.keyword);

  @override
  List<Object?> get props => [keyword];
}

class FinishedOrdersLoadMore extends OrdersEvent {
  const FinishedOrdersLoadMore();
}

class OrderRefused extends OrdersEvent {
  final String orderId;

  const OrderRefused(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
