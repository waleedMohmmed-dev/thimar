import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';

class AppSnackBar {
  AppSnackBar._();

  static SnackBar success(String message, ColorScheme colorScheme) {
    return _createSnackBar(
      message: message,
      icon: Icons.check_circle_rounded,
      backgroundColor: colorScheme.primary,
      iconColor: colorScheme.onPrimary,
    );
  }

  static SnackBar error(String message, ColorScheme colorScheme) {
    return _createSnackBar(
      message: message,
      icon: Icons.error_rounded,
      backgroundColor: colorScheme.error,
      iconColor: colorScheme.onError,
    );
  }

  static SnackBar _createSnackBar({
    required String message,
    required Color backgroundColor,
    required Color iconColor,
    IconData? icon,
  }) {
    return SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor, size: 22.sp),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: iconColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 4,
      duration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.horizontal,
    );
  }
}
