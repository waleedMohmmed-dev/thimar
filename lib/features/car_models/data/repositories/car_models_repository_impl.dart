import 'package:thimar/core/errors/exceptions.dart';
import 'package:thimar/core/errors/failures.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/car_models/data/datasources/car_models_remote_data_source.dart';
import 'package:thimar/features/car_models/domain/entities/car_model_entity.dart';
import 'package:thimar/features/car_models/domain/repositories/car_models_repository.dart';

class CarModelsRepositoryImpl implements CarModelsRepository {
  final CarModelsRemoteDataSource remoteDataSource;

  CarModelsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<CarModelEntity>>> getCarModels() async {
    try {
      final models = await remoteDataSource.getCarModels();
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
