import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/notifications/data/datasources/notifications_local_data_source.dart';
import 'package:thimar/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:thimar/features/notifications/domain/entities/notification_entity.dart';
import 'package:thimar/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;
  final NotificationsLocalDataSource localDataSource;

  NotificationsRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final notifications = await remoteDataSource.getNotifications();
      return Right(notifications);
    } catch (_) {
      return Right(localDataSource.getNotifications());
    }
  }
}
