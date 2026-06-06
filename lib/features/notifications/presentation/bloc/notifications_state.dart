import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/notifications/domain/entities/notification_entity.dart';

class NotificationsState extends Equatable {
  final List<NotificationEntity> notifications;
  final bool isLoading;
  final String? errorMessage;

  const NotificationsState({
    this.notifications = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  NotificationsState copyWith({
    List<NotificationEntity>? notifications,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [notifications, isLoading, errorMessage];
}
