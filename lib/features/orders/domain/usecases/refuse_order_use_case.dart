import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/repositories/orders_repository.dart';

class RefuseOrderUseCase {
  final OrdersRepository repository;

  RefuseOrderUseCase(this.repository);

  Future<Either<Failure, String>> call(String orderId) {
    return repository.refuseOrder(orderId);
  }
}
