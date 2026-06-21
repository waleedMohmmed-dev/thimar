import 'package:thimar/core/imports/core_imports.dart';

class AboutFeaturesSection extends StatelessWidget {
  const AboutFeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = context.theme.textTheme;
    final cs = context.theme.colorScheme;

    final features = [
      {
        'icon': Icons.local_shipping_rounded,
        'titleKey': 'feature_fast_delivery',
        'descKey': 'feature_fast_delivery_desc',
      },
      {
        'icon': Icons.eco_rounded,
        'titleKey': 'feature_fresh_products',
        'descKey': 'feature_fresh_products_desc',
      },
      {
        'icon': Icons.payment_rounded,
        'titleKey': 'feature_flexible_payment',
        'descKey': 'feature_flexible_payment_desc',
      },
      {
        'icon': Icons.star_rounded,
        'titleKey': 'feature_product_rating',
        'descKey': 'feature_product_rating_desc',
      },
      {
        'icon': Icons.account_balance_wallet_rounded,
        'titleKey': 'feature_digital_wallet',
        'descKey': 'feature_digital_wallet_desc',
      },
      {
        'icon': Icons.location_on_rounded,
        'titleKey': 'feature_multiple_addresses',
        'descKey': 'feature_multiple_addresses_desc',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مميزات التمار',
          style: tt.titleMedium?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        ...features.map(
          (f) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    f['icon'] as IconData,
                    color: cs.primary,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (f['titleKey'] as String).tr(),
                        style: tt.bodyLarge?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        (f['descKey'] as String).tr(),
                        style: tt.bodySmall?.copyWith(
                          color: cs.outline,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
