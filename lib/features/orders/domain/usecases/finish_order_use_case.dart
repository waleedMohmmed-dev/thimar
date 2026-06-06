import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/repositories/orders_repository.dart';

class FinishOrderUseCase {
  final OrdersRepository repository;

  FinishOrderUseCase(this.repository);

  Future<Either<Failure, String>> call(String orderId, double clientPaidAmount) {
    return repository.finishOrder(orderId, clientPaidAmount);
  }
}
