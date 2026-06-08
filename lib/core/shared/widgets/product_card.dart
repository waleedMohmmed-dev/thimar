import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/domain/entities/product_entity.dart';

/// Product card widget with discount badge, add to cart button, and favorite toggle
class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onAddToCart;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onAddToCart,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with discount badge and favorite button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  child: AppImage(
                    imageUrl: product.imageUrl,
                    height: 120.h,
                    fit: BoxFit.cover,
                  ),
                ),
                if (product.discount != null && product.discount! > 0)
                  PositionedDirectional(
                    top: 8.h,
                    start: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '${(product.discount! * 100).round()}%',
                        style: tt.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                PositionedDirectional(
                  top: 8.h,
                  end: 8.w,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: isFavorite ? Colors.transparent : cs.outline,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: isFavorite ? cs.primary : Colors.grey,
                        size: 20.r,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Product details
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                      fontSize: 16.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    product.unitName,
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                product.price.toStringAsFixed(1),
                                style: tt.titleSmall?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'sar'.tr(),
                              style: tt.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                                fontSize: 10.sp,
                              ),
                            ),
                            if (product.priceBeforeDiscount != null &&
                                product.priceBeforeDiscount! > product.price)
                              Padding(
                                padding: EdgeInsetsDirectional.only(start: 4.w),
                                child: Text(
                                  '${product.priceBeforeDiscount!.toStringAsFixed(1)} ${'sar'.tr()}',
                                  style: tt.bodySmall?.copyWith(
                                    color: cs.onSurfaceVariant,
                                    fontSize: 9.sp,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(width: 4.w),
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            color: cs.primary,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16.r,
                          ),
                        ),
                      ),
                    ],
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
