import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

class SummaryItemRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;
  final double? valueSize;

  const SummaryItemRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
    this.valueSize,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: tt.bodyMedium?.copyWith(
            color: cs.outline,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            fontSize: valueSize ?? 14.sp,
          ),
        ),
        Text(
          value,
          style: tt.bodyMedium?.copyWith(
            color: valueColor ?? cs.primary,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            fontSize: valueSize ?? 14.sp,
          ),
        ),
      ],
    );
  }
}
