import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/car_models/domain/entities/car_model_entity.dart';
import 'package:thimar/features/car_models/domain/repositories/car_models_repository.dart';

class GetCarModelsUseCase extends UseCase<List<CarModelEntity>, NoParams> {
  final CarModelsRepository repository;

  GetCarModelsUseCase(this.repository);

  @override
  Future<Either<Failure, List<CarModelEntity>>> call(NoParams params) async {
    return await repository.getCarModels();
  }
}
