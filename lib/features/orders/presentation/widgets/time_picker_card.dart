import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

class TimePickerCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const TimePickerCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        padding: EdgeInsets.all(12.w),
        backgroundColor: cs.surfaceContainerHighest,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: cs.primary, size: 20.sp),
            SizedBox(height: 8.h),
            Text(
              label,
              style: tt.bodySmall?.copyWith(color: cs.outline, fontSize: 12.sp),
            ),
            if (value.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Text(
                value,
                style: tt.bodyMedium?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
