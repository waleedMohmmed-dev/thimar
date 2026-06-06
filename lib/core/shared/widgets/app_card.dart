import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final double elevation;
  final bool hasBorder;

  const AppCard({
    Key? key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16),
    this.elevation = 2,
    this.hasBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(16.r),
      color: backgroundColor ?? cs.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: hasBorder
              ? Border.all(
                  color: cs.outline.withAlpha(77),
                  width: 1,
                )
              : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
