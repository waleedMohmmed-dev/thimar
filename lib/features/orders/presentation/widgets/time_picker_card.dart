import 'package:thimar/core/imports/core_imports.dart';

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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          border: Border.all(color: cs.outline.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: cs.primary, size: 22.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                value.isNotEmpty ? value : label,
                style: tt.bodyMedium?.copyWith(
                  color: value.isNotEmpty ? cs.primary : cs.outline,
                  fontWeight: value.isNotEmpty ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
