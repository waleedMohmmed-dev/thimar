import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';

class OrderInfoHeader extends StatelessWidget {
  final OrderEntity order;

  const OrderInfoHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: cs.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'pending_approval'.tr(),
                    style: tt.bodySmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '${order.total.toStringAsFixed(0)} ${'sar'.tr()}',
                  style: tt.headlineSmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 22.sp,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${'order_number'.tr()} ${order.id}',
                  style: tt.titleMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  order.dateKey.tr(),
                  style: tt.bodyMedium?.copyWith(
                    color: cs.outline,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Divider(height: 1.h, color: cs.outline.withAlpha(51)),
        SizedBox(height: 16.h),
        Row(
          children: [
            Icon(Icons.person, color: cs.primary, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'customer_name'.tr(),
                    style: tt.bodyMedium?.copyWith(
                      color: cs.outline,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    order.customerName ?? '-',
                    style: tt.bodyMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Icon(Icons.phone, color: cs.primary, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'phone_number'.tr(),
                    style: tt.bodyMedium?.copyWith(
                      color: cs.outline,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    order.phoneNumber ?? '-',
                    style: tt.bodyMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
