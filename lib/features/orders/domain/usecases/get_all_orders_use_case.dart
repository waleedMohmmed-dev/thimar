import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/repositories/client_orders_repository.dart';

class GetAllOrdersUseCase extends UseCase<List<OrderEntity>, NoParams> {
  final ClientOrdersRepository repository;

  GetAllOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) async {
    return repository.getAllOrders();
  }
}
