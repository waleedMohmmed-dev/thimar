import 'package:thimar/core/imports/packages_imports.dart';

class CarModelEntity extends Equatable {
  final String id;
  final String name;

  const CarModelEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
