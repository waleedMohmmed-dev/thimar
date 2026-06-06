import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/car_models/domain/entities/car_model_entity.dart';

class CarModelsState extends Equatable {
  final List<CarModelEntity> carModels;
  final bool isLoading;
  final String? errorMessage;

  const CarModelsState({
    this.carModels = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  CarModelsState copyWith({
    List<CarModelEntity>? carModels,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CarModelsState(
      carModels: carModels ?? this.carModels,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [carModels, isLoading, errorMessage];
}
