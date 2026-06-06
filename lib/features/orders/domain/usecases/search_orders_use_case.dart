import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/repositories/orders_repository.dart';

class SearchOrdersParams {
  final String keyword;

  const SearchOrdersParams({required this.keyword});
}

class SearchOrdersUseCase {
  final OrdersRepository repository;

  SearchOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call(SearchOrdersParams params) {
    return repository.searchFinishedOrders(params.keyword);
  }
}
