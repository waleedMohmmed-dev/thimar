import 'package:thimar/core/imports/core_imports.dart';

class GenderField extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String> onGenderChanged;

  const GenderField({
    super.key,
    this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الجنس',
          style: tt.bodyLarge?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: _GenderOption(
                label: 'ذكر',
                isSelected: selectedGender == 'male',
                onTap: () => onGenderChanged('male'),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _GenderOption(
                label: 'أنثى',
                isSelected: selectedGender == 'female',
                onTap: () => onGenderChanged('female'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outline,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: tt.bodyLarge?.copyWith(
              color: isSelected ? cs.onPrimary : cs.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
