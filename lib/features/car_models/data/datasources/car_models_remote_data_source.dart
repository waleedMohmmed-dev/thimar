import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/endpoints.dart';
import 'package:thimar/features/car_models/domain/entities/car_model_entity.dart';

abstract class CarModelsRemoteDataSource {
  Future<List<CarModelEntity>> getCarModels();
}

class CarModelsRemoteDataSourceImpl implements CarModelsRemoteDataSource {
  final ApiService _apiService;

  CarModelsRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<CarModelEntity>> getCarModels() async {
    final response = await _apiService.get(Endpoints.carModels);
    final List data = response['data'] ?? [];
    return data
        .map(
          (json) => CarModelEntity(
            id: json['id'].toString(),
            name: json['name'].toString(),
          ),
        )
        .toList();
  }
}
