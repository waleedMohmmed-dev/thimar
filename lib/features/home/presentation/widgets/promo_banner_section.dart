import 'package:thimar/core/imports/core_imports.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PromoBannerSection extends StatelessWidget {
  final List<String> banners;
  final int currentIndex;
  final void Function(int, CarouselPageChangedReason) onPageChanged;

  const PromoBannerSection({
    super.key,
    required this.banners,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return const SizedBox.shrink();

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
          items: banners.map((url) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: AppImage(
                imageUrl: url,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 12.h),
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
                    ? context.colorScheme.primary
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
