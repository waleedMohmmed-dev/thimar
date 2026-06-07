import 'package:thimar/features/notifications/domain/entities/notification_entity.dart';

class NotificationsLocalDataSource {
  static const List<NotificationEntity> _defaultNotifications = [
    NotificationEntity(
      id: '1',
      titleKey: 'notification_order_accepted_title',
      bodyKey: 'notification_order_accepted_body',
      timeKey: 'notification_time_1_minute',
      visual: NotificationVisual.document,
    ),
    NotificationEntity(
      id: '2',
      titleKey: 'notification_order_on_way_title',
      bodyKey: 'notification_order_on_way_body',
      timeKey: 'notification_time_30_minutes',
      visual: NotificationVisual.document,
    ),
    NotificationEntity(
      id: '3',
      titleKey: 'notification_order_delivered_title',
      bodyKey: 'notification_order_delivered_body',
      timeKey: 'notification_time_2_hours',
      visual: NotificationVisual.document,
    ),
    NotificationEntity(
      id: '4',
      titleKey: 'notification_admin_title',
      bodyKey: 'notification_admin_body',
      timeKey: 'notification_time_yesterday',
      visual: NotificationVisual.logo,
    ),
    NotificationEntity(
      id: '5',
      titleKey: 'notification_offers_title',
      bodyKey: 'notification_offers_body',
      timeKey: 'notification_time_3_days',
      visual: NotificationVisual.discount,
    ),
  ];

  List<NotificationEntity> getNotifications() => _defaultNotifications;
}
