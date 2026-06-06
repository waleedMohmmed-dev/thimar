import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

/// [AppNavBar] - Reusable bottom navigation bar matching the Thimar design.
///
/// Parameters:
/// - [currentIndex] - Currently selected tab index.
/// - [onTap] - Callback fired when a tab is selected.
/// - [items] - Navigation items displayed in the bar.
/// - [backgroundColor] - Optional custom background color.
class AppNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<AppNavBarItem> items;
  final Color? backgroundColor;

  const AppNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items = defaultItems,
    this.backgroundColor,
  });

  static const List<AppNavBarItem> defaultItems = [
    AppNavBarItem(labelKey: 'nav_home', icon: Icons.home_outlined),
    AppNavBarItem(labelKey: 'nav_orders', icon: Icons.receipt_long_outlined),
    AppNavBarItem(
      labelKey: 'nav_notifications',
      icon: Icons.notifications_none_outlined,
    ),
    AppNavBarItem(labelKey: 'nav_favorites', icon: Icons.favorite_border),
    AppNavBarItem(labelKey: 'nav_account', icon: Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final barColor = backgroundColor ?? cs.primary;

    return Container(
      decoration: BoxDecoration(
        color: barColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 12.r,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 86.h,
          child: Row(
            children: List.generate(items.length, (index) {
              return Expanded(
                child: _AppNavBarTile(
                  item: items[index],
                  isSelected: currentIndex == index,
                  onTap: () => onTap(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _AppNavBarTile extends StatelessWidget {
  final AppNavBarItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _AppNavBarTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final foregroundColor = isSelected
        ? cs.onPrimary
        : cs.onPrimary.withValues(alpha: 0.62);
    final labelStyle = tt.labelLarge?.copyWith(
      color: foregroundColor,
      fontSize: 13.sp,
      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w800,
      height: 1.15,
      shadows: [
        Shadow(
          color: Colors.black.withValues(alpha: isSelected ? 0.3 : 0.2),
          offset: Offset(0, 1.h),
          blurRadius: 1.r,
        ),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                color: foregroundColor,
                size: 36.r,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(
                      alpha: isSelected ? 0.22 : 0.14,
                    ),
                    offset: Offset(0, 1.h),
                    blurRadius: 1.r,
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                item.labelKey.tr(),
                style: labelStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppNavBarItem {
  final String labelKey;
  final IconData icon;

  const AppNavBarItem({required this.labelKey, required this.icon});
}
