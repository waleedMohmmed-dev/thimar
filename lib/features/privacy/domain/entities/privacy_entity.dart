import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

class PrivacyEntity extends Equatable {
  final String content;

  const PrivacyEntity({required this.content});

  @override
  List<Object?> get props => [content];
}
