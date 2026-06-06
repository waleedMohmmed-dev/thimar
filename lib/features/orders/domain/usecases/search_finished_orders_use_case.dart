import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/repositories/orders_repository.dart';

class SearchFinishedOrdersParams {
  final String keyword;

  const SearchFinishedOrdersParams({required this.keyword});
}

class SearchFinishedOrdersUseCase {
  final OrdersRepository repository;

  SearchFinishedOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call(
    SearchFinishedOrdersParams params,
  ) {
    return repository.searchFinishedOrders(params.keyword);
  }
}
