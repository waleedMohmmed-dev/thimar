import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/endpoints.dart';
import 'package:thimar/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationEntity>> getNotifications();
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final ApiService _apiService;

  NotificationsRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final response = await _apiService.get(Endpoints.notifications);
    final List data = response['data'] ?? [];
    return data.map((json) => NotificationEntity(
      id: json['id']?.toString() ?? '',
      titleKey: json['title']?.toString() ?? json['body']?.toString() ?? '',
      visual: _parseVisual(json['type']?.toString()),
    )).toList();
  }

  NotificationVisual _parseVisual(String? type) {
    return switch (type) {
      'order' => NotificationVisual.document,
      'offer' => NotificationVisual.discount,
      _ => NotificationVisual.logo,
    };
  }
}
