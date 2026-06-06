import 'package:thimar/core/imports/core_imports.dart';

class OtpHeader extends StatelessWidget {
  const OtpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'نسيت كلمة المرور',
          style: tt.headlineSmall?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 6.h),
        Text(
          'أدخل الكود المكون من 4 أرقام المرسل علي رقم الجوال',
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
