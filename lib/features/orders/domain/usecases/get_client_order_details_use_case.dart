import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/repositories/client_orders_repository.dart';

class GetClientOrderDetailsUseCase
    extends UseCase<OrderEntity, int> {
  final ClientOrdersRepository repository;

  GetClientOrderDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(int params) {
    return repository.getOrderDetails(params);
  }
}
