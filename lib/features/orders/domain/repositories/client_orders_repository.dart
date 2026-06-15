import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';

abstract class ClientOrdersRepository {
  Future<Either<Failure, List<OrderEntity>>> getCurrentOrders();
  Future<Either<Failure, List<OrderEntity>>> getFinishedOrders();
  Future<Either<Failure, List<OrderEntity>>> getAllOrders();
  Future<Either<Failure, OrderEntity>> getOrderDetails(int orderId);
  Future<Either<Failure, List<dynamic>>> getOrderProducts(int orderId);
  Future<Either<Failure, Map<String, dynamic>>> storeOrder(
    Map<String, dynamic> body,
  );
  Future<Either<Failure, Map<String, dynamic>>> getDeliveryCost(int addressId);
  Future<Either<Failure, Map<String, dynamic>>> deleteOrder(int orderId);
}
