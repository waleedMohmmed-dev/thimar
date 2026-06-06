import 'package:thimar/core/imports/core_imports.dart';

class PhoneDisplay extends StatelessWidget {
  final String phoneNumber;
  final VoidCallback onChangePhone;

  const PhoneDisplay({
    super.key,
    required this.phoneNumber,
    required this.onChangePhone,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              phoneNumber,
              style: tt.bodyLarge?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            GestureDetector(
              onTap: onChangePhone,
              child: Text(
                'تغيير رقم الجوال',
                style: tt.bodySmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
