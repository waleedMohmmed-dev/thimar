import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/repositories/orders_repository.dart';

class GetCurrentOrdersUseCase extends UseCase<List<OrderEntity>, NoParams> {
  final OrdersRepository repository;

  GetCurrentOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) {
    return repository.getCurrentOrders();
  }
}
