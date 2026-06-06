import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/errors/failures.dart';
import 'package:thimar/features/car_models/domain/entities/car_model_entity.dart';

abstract class CarModelsRepository {
  Future<Either<Failure, List<CarModelEntity>>> getCarModels();
}
