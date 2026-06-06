import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/data/datasources/client_orders_remote_data_source.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/repositories/client_orders_repository.dart';

class ClientOrdersRepositoryImpl implements ClientOrdersRepository {
  final ClientOrdersRemoteDataSource remoteDataSource;

  ClientOrdersRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<OrderEntity>>> getClientOrders() async {
    try {
      final orders = await remoteDataSource.getClientOrders();
      return Right(orders.map((order) => order.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
