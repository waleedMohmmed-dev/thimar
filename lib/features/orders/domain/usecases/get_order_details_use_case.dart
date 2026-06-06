import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/repositories/orders_repository.dart';

class GetOrderDetailsUseCase {
  final OrdersRepository repository;

  GetOrderDetailsUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call(String orderId) {
    return repository.getOrderDetails(orderId);
  }
}
