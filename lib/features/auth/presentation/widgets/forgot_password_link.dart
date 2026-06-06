import 'package:thimar/core/imports/core_imports.dart';

class ForgotPasswordLink extends StatelessWidget {
  final VoidCallback onTap;

  const ForgotPasswordLink({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          'نسيت كلمة المرور ؟',
          style: context.textTheme.bodySmall?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
