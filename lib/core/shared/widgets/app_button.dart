import 'package:thimar/core/imports/core_imports.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return SizedBox(
      width: width ?? double.infinity,
      height: _getHeight(),
      child: Material(
        color: _getBackgroundColor(cs),
        borderRadius: variant == ButtonVariant.outline
            ? null
            : BorderRadius.circular(12.r),
        shape: variant == ButtonVariant.outline
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(color: context.theme.primaryColor, width: 1.5),
              )
            : null,
        child: InkWell(
          onTap: isDisabled || isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12.r),
          child: Center(
            child: isLoading
              ? SizedBox(
                  height: _getIconSize(),
                  width: _getIconSize(),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(
                      _getTextColor(cs),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: _getTextColor(cs),
                        size: _getIconSize(),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      label,
                      style: _getTextStyle(context),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  double _getHeight() => switch (size) {
    ButtonSize.small => 36.h,
    ButtonSize.medium => 48.h,
    ButtonSize.large => 56.h,
  };

  double _getIconSize() => switch (size) {
    ButtonSize.small => 16.r,
    ButtonSize.medium => 20.r,
    ButtonSize.large => 24.r,
  };

  Color _getBackgroundColor(ColorScheme cs) {
    if (isDisabled) return cs.surfaceVariant;
    return switch (variant) {
      ButtonVariant.primary => cs.primary,
      ButtonVariant.secondary => cs.secondary,
      ButtonVariant.outline => Colors.transparent,
      ButtonVariant.error => cs.error,
    };
  }

  Color _getTextColor(ColorScheme cs) {
    if (isDisabled) return cs.onSurfaceVariant;
    return switch (variant) {
      ButtonVariant.primary => cs.onPrimary,
      ButtonVariant.secondary => cs.onSecondary,
      ButtonVariant.outline => cs.primary,
      ButtonVariant.error => cs.onError,
    };
  }

  TextStyle? _getTextStyle(BuildContext context) {
    final tt = context.textTheme;
    final cs = context.colorScheme;
    return tt.labelLarge?.copyWith(
      color: _getTextColor(cs),
      fontWeight: FontWeight.bold,
    );
  }
}

enum ButtonVariant { primary, secondary, outline, error }
enum ButtonSize { small, medium, large }
