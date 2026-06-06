import 'package:thimar/core/imports/packages_imports.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return SwitchListTile(
      title: Text('change_language'.tr()),
      subtitle: Text(isArabic ? 'العربية' : 'English'),
      value: isArabic,
      onChanged: (_) {
        final newLocale = isArabic ? const Locale('en') : const Locale('ar');
        context.setLocale(newLocale);
      },
    );
  }
}
