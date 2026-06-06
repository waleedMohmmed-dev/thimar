import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/repositories/orders_repository.dart';

class StartDeliveringOrderUseCase {
  final OrdersRepository repository;

  StartDeliveringOrderUseCase(this.repository);

  Future<Either<Failure, String>> call(String orderId) {
    return repository.startDeliveringOrder(orderId);
  }
}
