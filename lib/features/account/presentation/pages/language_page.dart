import 'package:thimar/core/imports/core_imports.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('change_language'.tr())),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Text(
              'hello'.tr(),
              style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40.h),
            const LanguageToggle(),
          ],
        ),
      ),
    );
  }
}
