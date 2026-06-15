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
              _buildRow(context, 'products_total'.tr(), productsTotal),
              SizedBox(height: 10.h),
              _buildRow(context, 'delivery_price'.tr(), deliveryPrice),
              SizedBox(height: 10.h),
              _buildRow(context, 'discount'.tr(), discount, isDiscount: true),
              Divider(height: 24.h, color: cs.outline.withValues(alpha: 0.3)),
              _buildRow(
                context,
                'total'.tr(),
                _calculateTotal(),
                isBold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _calculateTotal() {
    final products = double.tryParse(
          productsTotal.replaceAll(RegExp(r'[^0-9.]'), ''),
        ) ??
        0;
    final delivery = double.tryParse(
          deliveryPrice.replaceAll(RegExp(r'[^0-9.]'), ''),
        ) ??
        0;
    final disc = double.tryParse(
          discount.replaceAll(RegExp(r'[^0-9.-]'), ''),
        ) ??
        0;
    final total = products + delivery + disc;
    return '${total.toStringAsFixed(0)} ${'sar'.tr()}';
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    String value, {
    bool isDiscount = false,
    bool isBold = false,
  }) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: tt.bodyMedium?.copyWith(
            color: isBold ? cs.primary : cs.onSurfaceVariant,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            fontSize: isBold ? 16.sp : 14.sp,
          ),
        ),
        Text(
          value,
          style: tt.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: isDiscount
                ? cs.error
                : isBold
                    ? cs.primary
                    : cs.onSurface,
            fontSize: isBold ? 16.sp : 14.sp,
          ),
        ),
      ],
    );
  }
}
