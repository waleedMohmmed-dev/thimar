import 'package:thimar/core/imports/core_imports.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? hintText;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: AppTextField(
        controller: controller,
        onChanged: onChanged,
        hintText: hintText ?? 'search_order_hint'.tr(),
        prefixIcon: Icons.search,
        fillColor: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.3,
        ),
      ),
    );
  }
}

class EmptySearchState extends StatelessWidget {
  const EmptySearchState({super.key});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.search_off_outlined,
      title: 'no_search_results_title'.tr(),
      subtitle: 'no_search_results_subtitle'.tr(),
    );
  }
}
