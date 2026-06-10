import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/repositories/client_orders_repository.dart';

class GetDeliveryCostUseCase extends UseCase<Map<String, dynamic>, int> {
  final ClientOrdersRepository repository;

  GetDeliveryCostUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(int addressId) async {
    return repository.getDeliveryCost(addressId);
  }
}
