import 'package:thimar/core/imports/core_imports.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  void goRoleSelection() {
    go(AppRoutes.roleSelection);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      AppSnackBar.success(message, colorScheme),
    );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      AppSnackBar.success(message, colorScheme),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      AppSnackBar.error(message, colorScheme),
    );
  }

  Future<T?> showAppDialog<T>({required WidgetBuilder builder}) {
    return showDialog<T>(
      context: this,
      builder: builder,
    );
  }

  Future<T?> showAppBottomSheet<T>({required WidgetBuilder builder}) {
    return showModalBottomSheet<T>(
      context: this,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: builder,
    );
  }
}