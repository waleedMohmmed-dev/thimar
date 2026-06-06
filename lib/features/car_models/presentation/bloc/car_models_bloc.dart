import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/car_models/domain/usecases/get_car_models_use_case.dart';
import 'car_models_event.dart';
import 'car_models_state.dart';

class CarModelsBloc extends Bloc<CarModelsEvent, CarModelsState> {
  final GetCarModelsUseCase _getCarModelsUseCase;

  CarModelsBloc(this._getCarModelsUseCase) : super(const CarModelsState()) {
    on<CarModelsFetched>(_onFetched);
  }

  Future<void> _onFetched(
    CarModelsFetched event,
    Emitter<CarModelsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _getCarModelsUseCase(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (models) => emit(state.copyWith(
        isLoading: false,
        carModels: models,
      )),
    );
  }
}
