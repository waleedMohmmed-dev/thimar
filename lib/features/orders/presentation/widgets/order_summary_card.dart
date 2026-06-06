import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/presentation/widgets/summary_item_row.dart';

class OrderSummaryCard extends StatelessWidget {
  final OrderEntity order;

  const OrderSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return AppCard(
      backgroundColor: cs.primary.withAlpha(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'order_summary'.tr(),
            style: tt.titleMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 16.h),
          SummaryItemRow(
            label: 'total_products'.tr(),
            value: order.productsTotal ??
                '${order.total.toStringAsFixed(0)} ${'sar'.tr()}',
          ),
          SizedBox(height: 12.h),
          SummaryItemRow(
            label: 'delivery_price'.tr(),
            value: order.deliveryPrice ?? '0 ${'sar'.tr()}',
          ),
          if (order.discount != null) ...[
            SizedBox(height: 12.h),
            SummaryItemRow(
              label: 'discount'.tr(),
              value: order.discount!,
              valueColor: cs.error,
            ),
          ],
          Divider(height: 20.h, color: cs.outline.withAlpha(51)),
          SummaryItemRow(
            label: 'total'.tr(),
            value: '${order.total.toStringAsFixed(0)} ${'sar'.tr()}',
            isBold: true,
            valueSize: 16.sp,
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.payment, color: cs.primary, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    '${'payment_method'.tr()}: ${order.paymentMethod ?? '-'}',
                    style: tt.bodySmall?.copyWith(
                      color: cs.outline,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
