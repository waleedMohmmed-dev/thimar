import 'package:thimar/core/constants/app_assets.dart';
import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/notifications/domain/entities/notification_entity.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NotificationIcon(visual: notification.visual),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.titleKey.tr(),
                    style: tt.titleMedium?.copyWith(
                      color: cs.onSurface,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'notification_body_sample'.tr(),
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant.withValues(alpha: 0.46),
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.45,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'notification_time_two_hours_ago'.tr(),
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurface,
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  final NotificationVisual visual;

  const _NotificationIcon({required this.visual});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Container(
      width: 46.w,
      height: 46.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: switch (visual) {
        NotificationVisual.logo => Padding(
          padding: EdgeInsets.all(5.w),
          child: AppImage(imageUrl: AppAssets.logo, fit: BoxFit.contain),
        ),
        NotificationVisual.document => Icon(
          Icons.article_outlined,
          color: cs.primary,
          size: 31.r,
        ),
        NotificationVisual.discount => Icon(
          Icons.percent_rounded,
          color: cs.primary,
          size: 31.r,
        ),
      },
    );
  }
}
