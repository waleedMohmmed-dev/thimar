import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';

class AppError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const AppError({
    Key? key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64.r,
              color: cs.error,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: tt.bodyLarge?.copyWith(
                color: cs.onSurface,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: 16.h),
              AppButton(
                onPressed: onRetry!,
                label: 'retry'.tr(),
                variant: ButtonVariant.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
