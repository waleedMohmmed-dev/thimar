import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/wallet/domain/entities/wallet_entity.dart';
import 'package:thimar/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:thimar/features/wallet/data/datasources/wallet_remote_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, WalletEntity>> getWallet() async {
    try {
      final model = await remoteDataSource.getWallet();
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('unexpected_error'.tr()));
    }
  }
}
