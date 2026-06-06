import 'package:thimar/core/imports/core_imports.dart';

class ProductThumbnailsRow extends StatelessWidget {
  final List<String> productImages;
  final int extraProductsCount;

  const ProductThumbnailsRow({
    super.key,
    required this.productImages,
    required this.extraProductsCount,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (extraProductsCount > 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: cs.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              '+$extraProductsCount',
              style: TextStyle(
                color: cs.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ),
        if (extraProductsCount > 0) SizedBox(width: 6.w),
        ...List.generate(
          productImages.length.clamp(0, 3),
          (index) => Padding(
            padding: EdgeInsetsDirectional.only(start: 6.w),
            child: Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                border: Border.all(color: cs.primary, width: 1.5),
                borderRadius: BorderRadius.circular(8.r),
                image: DecorationImage(
                  image: AssetImage(productImages[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
