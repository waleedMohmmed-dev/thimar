import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

class NotesInputSection extends StatelessWidget {
  final TextEditingController controller;

  const NotesInputSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'notes_and_instructions'.tr(),
          style: tt.bodyLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        AppTextField(
          controller: controller,
          hintText: 'enter_notes'.tr(),
          maxLines: 4,
          minLines: 3,
        ),
      ],
    );
  }
}
