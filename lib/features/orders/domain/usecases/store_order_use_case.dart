import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/repositories/client_orders_repository.dart';

class StoreOrderUseCase
    implements UseCase<Map<String, dynamic>, Map<String, dynamic>> {
  final ClientOrdersRepository repository;

  StoreOrderUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    Map<String, dynamic> params,
  ) async {
    return repository.storeOrder(params);
  }
}
