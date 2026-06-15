import 'package:thimar/core/imports/core_imports.dart';

class HistoryEmptyState extends StatelessWidget {
  final VoidCallback? onRefresh;

  const HistoryEmptyState({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80.sp, color: cs.outline.withAlpha(100)),
          SizedBox(height: 16.h),
          Text(
            'no_transactions'.tr(),
            style: tt.titleMedium?.copyWith(
              color: cs.outline,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'no_transactions_desc'.tr(),
            style: tt.bodyMedium?.copyWith(color: cs.outline.withAlpha(150)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
