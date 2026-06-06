import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<OrderEntity>>> getPendingOrders() async {
    try {
      final orders = await remoteDataSource.getPendingOrders();
      return Right(orders.map((order) => order.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getCurrentOrders() async {
    try {
      final orders = await remoteDataSource.getCurrentOrders();
      return Right(orders.map((order) => order.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ({List<OrderEntity> orders, bool hasMore})>>
      getFinishedOrders({int page = 1}) async {
    try {
      final result = await remoteDataSource.getFinishedOrders(page: page);
      return Right((
        orders: result.orders.map((order) => order.toEntity()).toList(),
        hasMore: result.hasMore,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> searchCurrentOrders(
    String keyword,
  ) async {
    try {
      final orders = await remoteDataSource.searchCurrentOrders(keyword);
      return Right(orders.map((order) => order.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> searchFinishedOrders(
    String keyword,
  ) async {
    try {
      final orders = await remoteDataSource.searchFinishedOrders(keyword);
      return Right(orders.map((order) => order.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> refuseOrder(String orderId) async {
    try {
      final message = await remoteDataSource.refuseOrder(orderId);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderDetails(String orderId) async {
    try {
      final orderDetails = await remoteDataSource.getOrderDetails(orderId);
      return Right(orderDetails.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> acceptOrder(String orderId) async {
    try {
      final message = await remoteDataSource.acceptOrder(orderId);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> startDeliveringOrder(String orderId) async {
    try {
      final message = await remoteDataSource.startDeliveringOrder(orderId);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> finishOrder(
    String orderId,
    double clientPaidAmount,
  ) async {
    try {
      final message = await remoteDataSource.finishOrder(
        orderId,
        clientPaidAmount,
      );
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
