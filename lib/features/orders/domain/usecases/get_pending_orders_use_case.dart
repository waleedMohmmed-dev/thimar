import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/repositories/orders_repository.dart';

class GetPendingOrdersUseCase extends UseCase<List<OrderEntity>, NoParams> {
  final OrdersRepository repository;

  GetPendingOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) {
    return repository.getPendingOrders();
  }
}
