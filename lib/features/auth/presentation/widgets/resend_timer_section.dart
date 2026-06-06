import 'package:thimar/core/imports/core_imports.dart';

class ResendTimerSection extends StatelessWidget {
  final int remainingSeconds;
  final bool canResend;
  final VoidCallback onResend;
  final String Function(int) formatTime;

  const ResendTimerSection({
    super.key,
    required this.remainingSeconds,
    required this.canResend,
    required this.onResend,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      children: [
        Center(
          child: Text(
            'لم تستلم الكود ؟',
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
        ),
        SizedBox(height: 12.h),
        Center(
          child: Text(
            'يمكنك إعادة إرسال الكود بعد',
            style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ),
        SizedBox(height: 16.h),
        Center(
          child: Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: cs.outline, width: 3),
            ),
            child: Center(
              child: Text(
                formatTime(remainingSeconds),
                style: context.textTheme.headlineSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 24.h),
        if (canResend)
          AppButton(
            label: 'إعادة الإرسال',
            size: ButtonSize.large,
            onPressed: onResend,
          )
        else
          SizedBox(
            height: 56.h,
            child: Material(
              borderRadius: BorderRadius.circular(12.r),
              color: cs.surfaceVariant,
              child: Center(
                child: Text(
                  'إعادة الإرسال',
                  style: context.textTheme.labelLarge?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
