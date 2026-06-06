import 'package:thimar/core/imports/core_imports.dart';

class CompleteOrderSummaryWidget extends StatelessWidget {
  final String productsTotal;
  final String deliveryPrice;
  final String discount;

  const CompleteOrderSummaryWidget({
    super.key,
    required this.productsTotal,
    required this.deliveryPrice,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: cs.outline.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _buildRow(context, 'products_total'.tr(), productsTotal),
          SizedBox(height: 8.h),
          _buildRow(context, 'delivery_price'.tr(), deliveryPrice),
          SizedBox(height: 8.h),
          _buildRow(context, 'discount'.tr(), discount, isDiscount: true),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value, {bool isDiscount = false}) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
        Text(
          value,
          style: tt.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDiscount ? cs.error : cs.onSurface,
          ),
        ),
      ],
    );
  }
}
