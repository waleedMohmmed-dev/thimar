import 'package:thimar/core/imports/core_imports.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: AppTextField(
        controller: controller,
        onChanged: onChanged,
        fillColor: cs.surfaceContainerHighest,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        hintText: 'search_hint'.tr(),
        prefixIcon: Icons.search,
        suffixWidget: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: Colors.grey[400], size: 20.r),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              )
            : null,
      ),
    );
  }
}
