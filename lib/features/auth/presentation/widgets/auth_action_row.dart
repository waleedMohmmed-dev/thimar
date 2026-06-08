import 'package:thimar/core/imports/core_imports.dart';

class AuthActionRow extends StatelessWidget {
  final String label;
  final String actionLabel;
  final VoidCallback onActionTap;

  const AuthActionRow({
    super.key,
    required this.label,
    required this.actionLabel,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionLabel,
            style: tt.bodyMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(label, style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
      ],
    );
  }
}
