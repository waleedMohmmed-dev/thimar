import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';

abstract class ClientOrdersRepository {
  Future<Either<Failure, List<OrderEntity>>> getClientOrders();
}
