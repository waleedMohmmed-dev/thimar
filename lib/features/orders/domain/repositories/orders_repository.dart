import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<OrderEntity>>> getPendingOrders();

  Future<Either<Failure, List<OrderEntity>>> getCurrentOrders();

  Future<Either<Failure, ({List<OrderEntity> orders, bool hasMore})>>
      getFinishedOrders({int page = 1});

  Future<Either<Failure, List<OrderEntity>>> searchCurrentOrders(
    String keyword,
  );

  Future<Either<Failure, List<OrderEntity>>> searchFinishedOrders(
    String keyword,
  );

  Future<Either<Failure, String>> refuseOrder(String orderId);

  Future<Either<Failure, OrderEntity>> getOrderDetails(String orderId);

  Future<Either<Failure, String>> acceptOrder(String orderId);

  Future<Either<Failure, String>> startDeliveringOrder(String orderId);

  Future<Either<Failure, String>> finishOrder(
    String orderId,
    double clientPaidAmount,
  );
}
