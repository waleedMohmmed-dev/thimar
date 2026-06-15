import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/repositories/client_orders_repository.dart';

class DeleteClientOrderUseCase extends UseCase<Map<String, dynamic>, int> {
  final ClientOrdersRepository repository;

  DeleteClientOrderUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(int orderId) async {
    return repository.deleteOrder(orderId);
  }
}
