import 'package:thimar/core/imports/core_imports.dart';

class EmptySearchState extends StatelessWidget {
  const EmptySearchState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64.r,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'لا توجد نتائج',
              style: context.textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'جرب تبحث بكلمات مختلفة',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
