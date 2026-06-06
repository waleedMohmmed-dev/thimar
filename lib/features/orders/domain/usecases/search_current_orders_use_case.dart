import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/repositories/orders_repository.dart';

class SearchCurrentOrdersParams {
  final String keyword;

  const SearchCurrentOrdersParams({required this.keyword});
}

class SearchCurrentOrdersUseCase {
  final OrdersRepository repository;

  SearchCurrentOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call(
    SearchCurrentOrdersParams params,
  ) {
    return repository.searchCurrentOrders(params.keyword);
  }
}
