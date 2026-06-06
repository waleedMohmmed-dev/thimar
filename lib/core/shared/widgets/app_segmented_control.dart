import 'package:thimar/core/imports/core_imports.dart';

/// [AppSegmentedControl] - Premium reusable segmented toggle.
///
/// Parameters:
/// - [value] - Current selected value.
/// - [items] - Segment definitions with value and localization key.
/// - [onChanged] - Callback fired when a new segment is selected.
class AppSegmentedControl<T> extends StatelessWidget {
  final T value;
  final List<AppSegmentedControlItem<T>> items;
  final ValueChanged<T> onChanged;
  final double height;
  final Color? activeColor;
  final Color? backgroundColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;

  const AppSegmentedControl({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.height = 58,
    this.activeColor,
    this.backgroundColor,
    this.activeTextColor,
    this.inactiveTextColor,
  });

  @override
  Widget build(BuildContext context) {
    assert(items.isNotEmpty, 'AppSegmentedControl requires at least one item');

    final cs = context.colorScheme;
    final selectedIndex = items.indexWhere((item) => item.value == value);
    final effectiveIndex = selectedIndex < 0 ? 0 : selectedIndex;
    final controlHeight = height.h;
    final padding = 4.w;
    final radius = BorderRadius.circular(18.r);

    return Container(
      height: controlHeight,
      decoration: BoxDecoration(
        color: backgroundColor ?? cs.surface,
        borderRadius: radius,
        border: Border.all(color: cs.outline.withValues(alpha: 0.08), width: 1),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(padding),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / items.length;

          return Stack(
            children: [
              AnimatedPositionedDirectional(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                top: 0,
                bottom: 0,
                start: effectiveIndex * itemWidth,
                width: itemWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: activeColor ?? cs.primary,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: (activeColor ?? cs.primary).withValues(
                          alpha: 0.22,
                        ),
                        blurRadius: 14.r,
                        offset: Offset(0, 6.h),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: items.map((item) {
                  final isSelected = item.value == value;

                  return Expanded(
                    child: _AppSegmentedControlButton<T>(
                      item: item,
                      isSelected: isSelected,
                      activeTextColor: activeTextColor ?? cs.onPrimary,
                      inactiveTextColor:
                          inactiveTextColor ?? cs.onSurfaceVariant,
                      onTap: () {
                        if (!isSelected) {
                          onChanged(item.value);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AppSegmentedControlButton<T> extends StatelessWidget {
  final AppSegmentedControlItem<T> item;
  final bool isSelected;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final VoidCallback onTap;

  const _AppSegmentedControlButton({
    required this.item,
    required this.isSelected,
    required this.activeTextColor,
    required this.inactiveTextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = context.textTheme;
    final radius = BorderRadius.circular(15.r);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            style:
                tt.titleSmall?.copyWith(
                  color: isSelected ? activeTextColor : inactiveTextColor,
                  fontSize: 15.sp,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                  height: 1.2,
                ) ??
                TextStyle(
                  color: isSelected ? activeTextColor : inactiveTextColor,
                  fontSize: 15.sp,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                  height: 1.2,
                ),
            child: Text(
              item.labelKey.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class AppSegmentedControlItem<T> {
  final T value;
  final String labelKey;

  const AppSegmentedControlItem({required this.value, required this.labelKey});
}
