import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/transaction_history/data/datasources/transaction_history_remote_data_source.dart';
import 'package:thimar/features/transaction_history/domain/entities/transaction_entity.dart';
import 'package:thimar/features/transaction_history/domain/repositories/transaction_history_repository.dart';

class TransactionHistoryRepositoryImpl implements TransactionHistoryRepository {
  final TransactionHistoryRemoteDataSource remoteDataSource;

  TransactionHistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TransactionEntity>>>
  getTransactionHistory() async {
    try {
      final result = await remoteDataSource.getTransactionHistory();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactionHistoryByType(
    TransactionType type,
  ) async {
    try {
      final typeString = _getTypeString(type);
      final result = await remoteDataSource.getTransactionHistoryByType(
        typeString,
      );
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> getTransactionDetails(
    String transactionId,
  ) async {
    try {
      final all = await remoteDataSource.getTransactionHistory();
      final tx = all.firstWhere(
        (t) => t.id == transactionId,
        orElse: () => all.first,
      );
      return Right(tx.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  String _getTypeString(TransactionType type) {
    return switch (type) {
      TransactionType.walletTopUp => 'wallet_top_up',
      TransactionType.orderPayment => 'order_payment',
      TransactionType.walletWithdraw => 'wallet_withdraw',
      TransactionType.refund => 'refund',
      TransactionType.bonus => 'bonus',
    };
  }
}
