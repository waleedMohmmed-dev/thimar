import 'package:thimar/core/imports/core_imports.dart';

class MenuItemData {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLogout;

  MenuItemData({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLogout = false,
  });
}

class MenuItemsSection extends StatelessWidget {
  final bool isDriver;
  final VoidCallback onLogout;

  const MenuItemsSection({
    super.key,
    required this.isDriver,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final allItems = isDriver ? _driverItems(context) : _clientItems(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: allItems.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          return _MenuItemTile(item: allItems[index]);
        },
      ),
    );
  }

  List<MenuItemData> _driverItems(BuildContext context) {
    return [
      MenuItemData(
        icon: Icons.person,
        label: 'البيانات الشخصية',
        onTap: () => context.goProfile(),
      ),
      MenuItemData(
        icon: Icons.info,
        label: 'عن التطبيق',
        onTap: () => context.goAboutApp(),
      ),
      MenuItemData(
        icon: Icons.help_outline,
        label: 'أسئلة متكررة',
        onTap: () => context.goFaq(),
      ),
      MenuItemData(
        icon: Icons.privacy_tip,
        label: 'سياسة الخصوصية',
        onTap: () => context.goPrivacy(),
      ),
      MenuItemData(
        icon: Icons.contact_support,
        label: 'تواصل معنا',
        onTap: () => context.goContact(),
      ),
      MenuItemData(
        icon: Icons.report_problem,
        label: 'الشكاوي والأقتراحات',
        onTap: () => context.goContact(),
      ),
      MenuItemData(
        icon: Icons.logout,
        label: 'تسجيل الخروج',
        isLogout: true,
        onTap: onLogout,
      ),
    ];
  }

  List<MenuItemData> _clientItems(BuildContext context) {
    return [
      MenuItemData(
        icon: Icons.person,
        label: 'البيانات الشخصية',
        onTap: () => context.goProfile(),
      ),
      MenuItemData(
        icon: Icons.info,
        label: 'عن التطبيق',
        onTap: () => context.goAboutApp(),
      ),
      MenuItemData(
        icon: Icons.help,
        label: 'أسئلة متكررة',
        onTap: () => context.goFaq(),
      ),
      MenuItemData(
        icon: Icons.privacy_tip,
        label: 'سياسة الخصوصية',
        onTap: () => context.goPrivacy(),
      ),
      MenuItemData(
        icon: Icons.contact_support,
        label: 'تواصل معنا',
        onTap: () => context.goContact(),
      ),
      MenuItemData(
        icon: Icons.report_problem,
        label: 'الشكاوي والأقتراحات',
        onTap: () => context.goContact(),
      ),
      MenuItemData(
        icon: Icons.language,
        label: 'تغيير اللغة',
        onTap: () => context.goLanguage(),
      ),
      MenuItemData(
        icon: Icons.logout,
        label: 'تسجيل الخروج',
        isLogout: true,
        onTap: onLogout,
      ),
    ];
  }
}

class _MenuItemTile extends StatelessWidget {
  final MenuItemData item;

  const _MenuItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: item.isLogout
                    ? Colors.red.withValues(alpha: 0.1)
                    : cs.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                item.icon,
                color: item.isLogout ? Colors.red[400] : cs.primary,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: item.isLogout ? Colors.red[400] : cs.onSurface,
                ),
              ),
            ),
            Icon(Icons.chevron_left, size: 16.sp, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
