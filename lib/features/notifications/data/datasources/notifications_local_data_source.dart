import 'package:thimar/features/notifications/domain/entities/notification_entity.dart';

class NotificationsLocalDataSource {
  static const List<NotificationEntity> _defaultNotifications = [
    NotificationEntity(
      id: '1',
      titleKey: 'notification_order_accepted_title',
      visual: NotificationVisual.document,
    ),
    NotificationEntity(
      id: '2',
      titleKey: 'notification_admin_title',
      visual: NotificationVisual.logo,
    ),
    NotificationEntity(
      id: '3',
      titleKey: 'notification_offers_title',
      visual: NotificationVisual.discount,
    ),
  ];

  List<NotificationEntity> getNotifications() => _defaultNotifications;
}
