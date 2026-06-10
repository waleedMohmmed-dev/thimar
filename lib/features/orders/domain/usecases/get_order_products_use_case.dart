import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/repositories/client_orders_repository.dart';

class GetOrderProductsUseCase extends UseCase<List<dynamic>, int> {
  final ClientOrdersRepository repository;

  GetOrderProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<dynamic>>> call(int orderId) async {
    return repository.getOrderProducts(orderId);
  }
}
