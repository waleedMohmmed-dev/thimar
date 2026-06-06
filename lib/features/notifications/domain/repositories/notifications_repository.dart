import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
}
