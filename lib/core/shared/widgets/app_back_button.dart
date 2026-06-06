import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? backgroundColor;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Padding(
      padding: EdgeInsets.all(8.r),
      child: InkWell(
        onTap: onPressed ?? () => context.pop(),
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: backgroundColor ?? cs.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: iconColor ?? cs.primary,
            size: 18.r,
          ),
        ),
      ),
    );
  }
}
