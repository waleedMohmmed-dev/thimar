import 'package:thimar/core/imports/packages_imports.dart';

abstract class CarModelsEvent extends Equatable {
  const CarModelsEvent();

  @override
  List<Object> get props => [];
}

class CarModelsFetched extends CarModelsEvent {
  const CarModelsFetched();
}
