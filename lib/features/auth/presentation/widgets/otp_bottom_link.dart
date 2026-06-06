import 'package:thimar/core/imports/core_imports.dart';

class OtpBottomLink extends StatelessWidget {
  final VoidCallback onLoginTap;

  const OtpBottomLink({
    super.key,
    required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onLoginTap,
          child: Text(
            'تسجيل الدخول',
            style: tt.bodyMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          ' لديك حساب بالفعل ؟',
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}
