import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';

class DeliveryAddressSection extends StatelessWidget {
  final OrderEntity order;

  const DeliveryAddressSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'delivery_address'.tr(),
          style: tt.titleMedium?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Colors.grey[400],
                image: const DecorationImage(
                  image: AssetImage('assets/images/map_placeholder.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 40.sp,
                    ),
                  ),
                  PositionedDirectional(
                    bottom: 8.w,
                    end: 8.w,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'delivery_address'.tr(),
                    style: tt.titleSmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  if (order.address != null) ...[
                    Text(
                      order.address!,
                      style: tt.bodySmall?.copyWith(
                        color: cs.outline,
                        fontSize: 12.sp,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ] else ...[
                    Text(
                      'no_address'.tr(),
                      style: tt.bodySmall?.copyWith(
                        color: cs.outline,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
