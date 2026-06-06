import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

class ProductCarouselSection extends StatelessWidget {
  final List<String> products;
  final int currentProductIndex;
  final ValueChanged<int> onPageChanged;
  final PageController pageController;

  const ProductCarouselSection({
    super.key,
    required this.products,
    required this.currentProductIndex,
    required this.onPageChanged,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                if (currentProductIndex > 0) {
                  pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: cs.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.chevron_left, color: cs.primary, size: 24.sp),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 80.h,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) {
                    onPageChanged(index);
                  },
                  itemCount: products.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: cs.primary, width: 2),
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                          image: AssetImage(products[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 40.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: cs.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '+2',
                    style: tt.titleMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            (products.length / 2).ceil(),
            (index) => Container(
              width: 8.w,
              height: 8.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentProductIndex == index
                    ? cs.primary
                    : cs.primary.withAlpha(100),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
