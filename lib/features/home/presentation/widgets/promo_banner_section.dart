import 'package:thimar/core/imports/core_imports.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PromoBannerSection extends StatelessWidget {
  final int currentIndex;
  final void Function(int, CarouselPageChangedReason) onPageChanged;

  const PromoBannerSection({
    super.key,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final banners = [
      {
        'gradient': [cs.primary, cs.secondary],
        'icon': Icons.shopping_basket,
        'title': 'upto'.tr(),
        'discount': '50%',
        'subtitle': 'off'.tr(),
      },
      {
        'gradient': [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
        'icon': Icons.local_fire_department,
        'title': 'عروض خاصة',
        'discount': '30%',
        'subtitle': 'خصم',
      },
      {
        'gradient': [const Color(0xFF667EEA), const Color(0xFF764BA2)],
        'icon': Icons.star,
        'title': 'منتجات جديدة',
        'discount': 'جديد',
        'subtitle': 'اكتشف الآن',
      },
    ];

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180.h,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            onPageChanged: onPageChanged,
          ),
          items: banners.map((banner) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: banner['gradient'] as List<Color>,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Icon(
                      banner['icon'] as IconData,
                      size: 100.r,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  PositionedDirectional(
                    bottom: 16.h,
                    end: 16.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            banner['title'] as String,
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: cs.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFFFD700),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              banner['discount'] as String,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            banner['subtitle'] as String,
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 12.h),
        // Indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: banners.asMap().entries.map((entry) {
            return Container(
              width: 8.w,
              height: 8.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == entry.key
                    ? cs.primary
                    : Colors.grey[300],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
