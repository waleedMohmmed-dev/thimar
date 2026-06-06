import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/entities/product_entity.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';
import 'package:thimar/features/home/data/datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final productModels = await remoteDataSource.getProducts();
      final entities = productModels.map((model) => model.toEntity()).toList();
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
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String keyword) async {
    try {
      final productModels = await remoteDataSource.searchProducts(keyword);
      final entities = productModels.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
