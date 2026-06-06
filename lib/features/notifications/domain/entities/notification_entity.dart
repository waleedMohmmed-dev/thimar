import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

enum NotificationVisual { document, logo, discount }

class NotificationEntity extends Equatable {
  final String id;
  final String titleKey;
  final NotificationVisual visual;

  const NotificationEntity({
    required this.id,
    required this.titleKey,
    required this.visual,
  });

  @override
  List<Object?> get props => [id, titleKey, visual];
}
