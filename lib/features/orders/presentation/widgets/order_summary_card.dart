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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'order_summary'.tr(),
          style: tt.bodyLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              SummaryItemRow(
                label: 'total_products'.tr(),
                value:
                    order.productsTotal ??
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
              Divider(height: 24.h, color: cs.outline.withValues(alpha: 0.3)),
              SummaryItemRow(
                label: 'total'.tr(),
                value: '${order.total.toStringAsFixed(0)} ${'sar'.tr()}',
                isBold: true,
                valueSize: 16.sp,
              ),
              SizedBox(height: 14.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تم الدفع بواسطة',
                    style: tt.bodySmall?.copyWith(
                      color: cs.outline,
                      fontSize: 13.sp,
                    ),
                  ),
                  _buildPaymentIcon(context, order.paymentMethod),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentIcon(BuildContext context, String? method) {
    final cs = context.colorScheme;

    if (method == 'visa') {
      return Image.asset(
        'assets/images/visa.png',
        width: 40.w,
        height: 24.h,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.credit_card,
          color: cs.primary,
          size: 28.sp,
        ),
      );
    }
    if (method == 'mastercard') {
      return Image.asset(
        'assets/images/masstercard.png',
        width: 40.w,
        height: 24.h,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.credit_card,
          color: cs.primary,
          size: 28.sp,
        ),
      );
    }
    return Icon(
      Icons.money,
      color: cs.primary,
      size: 28.sp,
    );
  }
}
