import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

class NotesDisplaySection extends StatelessWidget {
  final String notes;

  const NotesDisplaySection({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'notes_and_instructions'.tr(),
          style: tt.titleMedium?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            notes,
            style: tt.bodyMedium?.copyWith(
              color: cs.primary,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
