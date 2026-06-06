import 'package:thimar/core/imports/core_imports.dart';

/// Category card widget displaying category image and name
class CategoryCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.label,
    required this.imagePath,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16.r),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: tt.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
