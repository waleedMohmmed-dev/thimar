import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/routing/app_router.dart';
import 'package:thimar/features/auth/presentation/pages/verify_otp_page.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';

/// ============================================================================
/// [NavigationExtensions] - Easy navigation from anywhere in the app
/// ============================================================================
///
/// Auth routes use go() to prevent back-navigation to login pages.
/// Non-auth routes use push() so pop() works correctly for back navigation.
///

extension NavigationExtensions on BuildContext {
  // =========== SPLASH ===========
  void goSplash() => go(AppRoutes.splash);

  // =========== AUTH NAVIGATION (go - no back stack) ===========
  void goLogin(String userType) => go('${AppRoutes.login}/$userType');
  void goDriverRegistration() => go(AppRoutes.driverRegistration);
  void goForgotPassword() => go(AppRoutes.forgotPassword);
  void goVerifyOtp(String phoneNumber, {VerifyPurpose purpose = VerifyPurpose.registration}) =>
      go(RouteArguments.verifyOtpPath(phoneNumber), extra: purpose);
  void goNewPassword(String phoneNumber, String otp) =>
      go(RouteArguments.newPasswordPath(phoneNumber, otp));

  // =========== MAIN APP NAVIGATION ===========
  void goHome() => go(AppRoutes.home);

  void goProfile() => push(AppRoutes.profile);
  void goAccount() => push(AppRoutes.account);
  void goNotifications() => push(AppRoutes.notifications);

  // =========== ORDERS NAVIGATION ===========
  void goOrders() => push(AppRoutes.orders);
  void goCurrentOrders() => push(AppRoutes.currentOrders);
  void goFinishedOrders() => push(AppRoutes.finishedOrders);
  void goPendingOrderDetails(OrderEntity order) =>
      push(AppRoutes.pendingOrderDetails, extra: order);

  // =========== SETTINGS & INFO ===========
  void goFaq() => push(AppRoutes.faq);
  void goPrivacy() => push(AppRoutes.privacy);
  void goContact() => push(AppRoutes.contact);
  void goAboutApp() => push(AppRoutes.aboutApp);
  void goLanguage() => push(AppRoutes.language);

  // =========== UTILITY NAVIGATION ===========
  /// Go back to previous screen
  void goBack() {
    if (GoRouter.of(this).canPop()) {
      GoRouter.of(this).pop();
    }
  }

  /// Replace current route with new route (no back button)
  void replaceWith(String location) => go(location);
}
