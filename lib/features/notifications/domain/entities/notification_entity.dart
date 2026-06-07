import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

enum NotificationVisual { document, logo, discount }

class NotificationEntity extends Equatable {
  final String id;
  final String titleKey;
  final String bodyKey;
  final String timeKey;
  final NotificationVisual visual;

  const NotificationEntity({
    required this.id,
    required this.titleKey,
    required this.visual,
    this.bodyKey = 'notification_body_sample',
    this.timeKey = 'notification_time_two_hours_ago',
  });

  @override
  List<Object?> get props => [id, titleKey, bodyKey, timeKey, visual];
}
