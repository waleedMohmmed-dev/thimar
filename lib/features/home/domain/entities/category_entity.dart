import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final String media;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.media,
  });

  @override
  List<Object?> get props => [id, name, description, media];
}
