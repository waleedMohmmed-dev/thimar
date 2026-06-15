import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'package:thimar/features/wallet/data/models/wallet_transaction_model.dart';
import 'package:thimar/features/wallet/domain/entities/wallet_transaction_entity.dart';
import 'package:thimar/features/wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> chargeWallet({
    required double amount,
    required String transactionId,
  }) async {
    try {
      final data = await remoteDataSource.chargeWallet(
        amount: amount,
        transactionId: transactionId,
      );
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getWalletBalance() async {
    try {
      final data = await remoteDataSource.getWallet();
      final balance = (data['wallet'] as num?)?.toDouble() ?? 0;
      return Right(balance);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WalletTransactionEntity>>>
      getWalletTransactions() async {
    try {
      final models = await remoteDataSource.getWalletTransactions();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> cashoutWallet(
    double amount,
  ) async {
    try {
      final data = await remoteDataSource.cashoutWallet(amount);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
