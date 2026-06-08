import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:thimar/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:thimar/features/notifications/presentation/bloc/notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsRepository _notificationsRepository;

  NotificationsBloc({required NotificationsRepository notificationsRepository})
    : _notificationsRepository = notificationsRepository,
      super(const NotificationsState()) {
    on<NotificationsFetched>(_onNotificationsFetched);
  }

  Future<void> _onNotificationsFetched(
    NotificationsFetched event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _notificationsRepository.getNotifications();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (notifications) =>
          emit(state.copyWith(isLoading: false, notifications: notifications)),
    );
  }
}
