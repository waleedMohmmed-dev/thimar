import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/cache/cache_constants.dart';
import 'package:thimar/core/cache/cache_keys.dart';
import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/presentation/widgets/order_status_badge.dart';

class OrderInfoHeader extends StatelessWidget {
  final OrderEntity order;

  const OrderInfoHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    final userName = sl<HiveCacheService>().get<String>(
          key: CacheKeys.userName,
          boxName: CacheConstants.userBox,
        ) ??
        'عميل';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OrderStatusBadge(status: order.status),
              Text(
                '${'order_number'.tr()} ${order.id}',
                style: tt.titleMedium?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.person, color: cs.primary, size: 18.sp),
              SizedBox(width: 6.w),
              Text(
                userName,
                style: tt.bodyLarge?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.total.toStringAsFixed(0)} ${'sar'.tr()}',
                style: tt.headlineSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 20.sp,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (order.deliveryDate != null &&
                      order.deliveryDate!.isNotEmpty)
                    Text(
                      _formatDate(order.deliveryDate!),
                      style: tt.bodyMedium?.copyWith(
                        color: cs.outline,
                        fontSize: 13.sp,
                      ),
                    ),
                  if (order.deliveryTime != null &&
                      order.deliveryTime!.isNotEmpty)
                    Text(
                      _formatTime(order.deliveryTime!),
                      style: tt.bodyMedium?.copyWith(
                        color: cs.outline,
                        fontSize: 13.sp,
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (order.productImagePaths.isNotEmpty) ...[
            SizedBox(height: 16.h),
            _buildProductImages(context, order),
          ],
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        final months = [
          '',
          'يناير',
          'فبراير',
          'مارس',
          'أبريل',
          'مايو',
          'يونيو',
          'يوليو',
          'أغسطس',
          'سبتمبر',
          'أكتوبر',
          'نوفمبر',
          'ديسمبر',
        ];
        final day = int.parse(parts[2]);
        final month = int.parse(parts[1]);
        return '$day ${months[month]} ${parts[0]}';
      }
      return dateStr;
    } catch (_) {
      return dateStr;
    }
  }

  String _formatTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        int hour = int.parse(parts[0]);
        final minute = parts[1];
        final period = hour >= 12 ? 'م' : 'ص';
        if (hour > 12) hour -= 12;
        if (hour == 0) hour = 12;
        return '$hour:$minute $period';
      }
      return timeStr;
    } catch (_) {
      return timeStr;
    }
  }

  Widget _buildProductImages(BuildContext context, OrderEntity order) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final displayCount = order.productImagePaths.length.clamp(0, 3);
    final extraCount = order.extraProductsCount > 0
        ? order.extraProductsCount
        : order.productImagePaths.length - displayCount;

    return Row(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.chevron_left,
              color: cs.primary,
              size: 22.sp,
            ),
          ),
        ),
        const Spacer(),
        if (extraCount > 0)
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                '+$extraCount',
                style: tt.bodySmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        if (extraCount > 0) SizedBox(width: 6.w),
        ...List.generate(displayCount, (i) {
          return Padding(
            padding: EdgeInsets.only(left: 6.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: AppImage(
                imageUrl: order.productImagePaths[i],
                width: 36.w,
                height: 36.h,
                fit: BoxFit.cover,
              ),
            ),
          );
        }),
      ],
    );
  }
}
