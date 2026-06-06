import 'package:thimar/core/imports/core_imports.dart';

class CancelOrderButton extends StatelessWidget {
  final VoidCallback onTap;

  const CancelOrderButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: cs.error.withAlpha(30),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            'cancel_order'.tr(),
            style: tt.labelLarge?.copyWith(
              color: cs.error,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}
