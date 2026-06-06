import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:thimar/features/notifications/presentation/bloc/notifications_state.dart';
import 'package:thimar/features/notifications/presentation/widgets/notifications_widgets.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _NotificationsView();
  }
}

class _NotificationsView extends StatefulWidget {
  const _NotificationsView();

  @override
  State<_NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<_NotificationsView> {
  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: AppLoading());
        }

        final notifications = state.notifications;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 28.h, 16.w, 24.h),
          child: Column(
            children: [
              Text(
                'notifications_title'.tr(),
                style: tt.headlineSmall?.copyWith(
                  color: cs.primary,
                  fontSize: 27.sp,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 58.h),
              if (notifications.isEmpty)
                AppEmptyState(
                  icon: Icons.notifications_none_outlined,
                  title: 'no_notifications_title'.tr(),
                  subtitle: 'no_notifications_subtitle'.tr(),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => SizedBox(height: 18.h),
                  itemBuilder: (context, index) {
                    return NotificationCard(notification: notifications[index]);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
