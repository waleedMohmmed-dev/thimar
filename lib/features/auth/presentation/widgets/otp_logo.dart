import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/constants/app_assets.dart';

class OtpLogo extends StatelessWidget {
  const OtpLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        AppAssets.logo,
        height: 160.h,
        width: 160.w,
        fit: BoxFit.contain,
      ),
    );
  }
}
