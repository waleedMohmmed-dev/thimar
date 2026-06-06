import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/repositories/orders_repository.dart';

class GetFinishedOrdersUseCase
    extends UseCase<({List<OrderEntity> orders, bool hasMore}), int> {
  final OrdersRepository repository;

  GetFinishedOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, ({List<OrderEntity> orders, bool hasMore})>> call(
    int page,
  ) {
    return repository.getFinishedOrders(page: page);
  }
}
