import 'package:thimar/core/imports/core_imports.dart';

class ProfileSaveButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ProfileSaveButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 64.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
        child: Text(
          'edit_profile'.tr(),
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
