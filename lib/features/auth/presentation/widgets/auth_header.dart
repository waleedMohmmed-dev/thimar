import 'package:thimar/core/imports/core_imports.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextAlign align;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.align = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: align == TextAlign.start
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: tt.headlineSmall?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
          textAlign: align,
        ),
        SizedBox(height: 6.h),
        Text(
          subtitle,
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          textAlign: align,
        ),
      ],
    );
  }
}
