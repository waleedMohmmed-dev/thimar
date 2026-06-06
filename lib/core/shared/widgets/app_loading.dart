import 'package:thimar/core/imports/core_imports.dart';

class AppLoading extends StatelessWidget {
  final String? message;
  final Color? color;

  const AppLoading({
    super.key,
    this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(
              color ?? cs.primary,
            ),
            strokeWidth: 3,
          ),
          if (message != null) ...[
            SizedBox(height: 16.h),
            Text(
              message!,
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
