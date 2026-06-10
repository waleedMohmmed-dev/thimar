import 'dart:async';
import 'package:thimar/core/cache/cache_constants.dart';
import 'package:thimar/core/cache/cache_keys.dart';
import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/core/models/user_role.dart';

import 'package:thimar/core/networking/dio_client.dart';
import 'package:thimar/core/services/screen_tracker_service.dart';

// Splash Page
import 'package:thimar/features/splash/presentation/pages/splash_page.dart';

// Auth Pages
import 'package:thimar/features/auth/presentation/pages/login_page.dart';
import 'package:thimar/features/auth/presentation/pages/driver_registration_page.dart';
import 'package:thimar/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:thimar/features/auth/presentation/pages/verify_otp_page.dart';
import 'package:thimar/features/auth/presentation/pages/new_password_page.dart';

// Onboarding Pages
import 'package:thimar/presentation/onboarding/role_selection_page.dart';

// Main App Pages
import 'package:thimar/features/home/presentation/pages/home_page.dart';
import 'package:thimar/features/profile/presentation/pages/profile_page.dart';
import 'package:thimar/features/account/presentation/pages/account_page.dart';
import 'package:thimar/features/account/presentation/pages/language_page.dart';
import 'package:thimar/features/notifications/presentation/pages/notifications_page.dart';

// Products Pages
import 'package:thimar/features/products/presentation/pages/product_details_page.dart';
import 'package:thimar/features/products/presentation/pages/category_products_page.dart';
import 'package:thimar/features/products/presentation/pages/cart_page.dart';

// Orders Pages
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/presentation/pages/orders_page.dart';
import 'package:thimar/features/orders/presentation/pages/current_orders_page.dart';
import 'package:thimar/features/orders/presentation/pages/finished_orders_page.dart';
import 'package:thimar/features/orders/presentation/pages/pending_order_details_page.dart';
import 'package:thimar/features/orders/presentation/pages/client_order_details_page.dart';
import 'package:thimar/features/orders/presentation/bloc/order_details_cubit.dart';
import 'package:thimar/features/orders/domain/usecases/get_order_details_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/accept_order_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/refuse_order_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/start_delivering_order_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/finish_order_use_case.dart';

// Settings & Info Pages
import 'package:thimar/features/faq/presentation/pages/faq_page.dart';
import 'package:thimar/features/privacy/presentation/pages/privacy_page.dart';
import 'package:thimar/features/contact/presentation/pages/contact_page.dart';
import 'package:thimar/features/about_app/presentation/pages/about_app_page.dart';

/// ============================================================================
/// [AppRoutes] - Centralized route path definitions
/// ============================================================================
class AppRoutes {
  // =========== ONBOARDING ===========
  static const String roleSelection = '/role-selection';

  // =========== SPLASH ===========
  static const String splash = '/splash';

  // =========== AUTH FLOW ===========
  static const String login = '/login';
  static const String driverRegistration = '/driver-registration';
  static const String clientRegistration = '/client-registration';
  static const String forgotPassword = '/forgot-password';
  static const String verifyOtp = '/verify-otp';
  static const String newPassword = '/new-password';

  // =========== MAIN APP SHELL ===========
  static const String home = '/';
  static const String profile = '/profile';
  static const String account = '/account';
  static const String notifications = '/notifications';

  // =========== PRODUCTS FLOW ===========
  static const String productDetails = '/product-details';
  static const String categoryProducts = '/category-products';
  static const String cart = '/cart';

  // =========== ORDERS FLOW ===========
  static const String orders = '/orders';
  static const String currentOrders = '/current-orders';
  static const String finishedOrders = '/finished-orders';
  static const String pendingOrderDetails = '/pending-order-details';
  static const String clientOrderDetails = '/client-order-details';

  // =========== SETTINGS & INFO ===========
  static const String faq = '/faq';
  static const String privacy = '/privacy';
  static const String contact = '/contact';
  static const String aboutApp = '/about-app';
  static const String language = '/language';
}

/// ============================================================================
/// Helper function to build typed route names
/// ============================================================================
class RouteArguments {
  static String verifyOtpPath(String phoneNumber) {
    return '${AppRoutes.verifyOtp}/$phoneNumber';
  }

  static String newPasswordPath(String phoneNumber, String otp) {
    return '${AppRoutes.newPassword}/$phoneNumber/$otp';
  }
}

/// RTL-aware slide transition builder
SlideTransition _rtlAwareSlideTransition({
  required Animation<double> animation,
  required Animation<double> secondaryAnimation,
  required Widget child,
  required BuildContext context,
}) {
  final isRtl = Directionality.of(context) == TextDirection.rtl;
  return SlideTransition(
    position: Tween<Offset>(
      begin: Offset(isRtl ? -1 : 1, 0),
      end: Offset.zero,
    ).animate(animation),
    child: child,
  );
}

/// Set of routes that require authentication
const _protectedRoutes = {
  AppRoutes.home,
  AppRoutes.profile,
  AppRoutes.account,
  AppRoutes.notifications,
  AppRoutes.productDetails,
  AppRoutes.categoryProducts,
  AppRoutes.cart,
  AppRoutes.orders,
  AppRoutes.currentOrders,
  AppRoutes.finishedOrders,
  AppRoutes.pendingOrderDetails,
  AppRoutes.clientOrderDetails,
};

/// Check if a path (or its prefix) requires authentication
bool _isProtectedRoute(String location) {
  for (final route in _protectedRoutes) {
    if (location == route || location.startsWith('$route/')) {
      return true;
    }
  }
  return false;
}

/// Auth-allowed routes (no auth needed)
const _publicRoutes = {
  AppRoutes.roleSelection,
  AppRoutes.splash,
  AppRoutes.login,
  AppRoutes.driverRegistration,
  AppRoutes.clientRegistration,
  AppRoutes.forgotPassword,
};

bool _isPublicRoute(String location) {
  for (final route in _publicRoutes) {
    if (location == route || location.startsWith('$route/')) {
      return true;
    }
  }
  return false;
}

class ScreenTrackerObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _updateScreen(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _updateScreen(previousRoute);
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _updateScreen(newRoute);
    }
  }

  void _updateScreen(Route route) {
    final name = route.settings.name ?? route.settings.arguments?.toString();
    if (name != null) {
      ScreenTrackerService.currentScreen = name;
    } else {
      ScreenTrackerService.currentScreen = route.toString();
    }
  }
}

/// ============================================================================
/// [goRouter] - Global GoRouter configuration with auth guard
/// ============================================================================
final goRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  observers: [ScreenTrackerObserver()],
  refreshListenable: GoRouterRefreshStream(DioClient.onUnauthorized),
  redirect: (context, state) {
    final cacheService = sl<HiveCacheService>();
    final token = cacheService.get<String>(
      key: CacheKeys.token,
      boxName: CacheConstants.userBox,
    );
    final isLoggedIn = token != null && token.isNotEmpty;
    final location = state.matchedLocation;

    // Public routes - always accessible
    if (_isPublicRoute(location)) {
      if (isLoggedIn &&
          (location == AppRoutes.roleSelection ||
              location == AppRoutes.splash)) {
        return AppRoutes.home;
      }
      return null;
    }

    // Protected routes - require authentication
    if (!isLoggedIn && _isProtectedRoute(location)) {
      return AppRoutes.login;
    }

    return null;
  },
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('404 - Route Not Found'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
  routes: [
    // =========== ONBOARDING ===========
    GoRoute(
      path: AppRoutes.roleSelection,
      name: 'Role Selection',
      pageBuilder: (context, state) => NoTransitionPage<void>(
        key: state.pageKey,
        child: const RoleSelectionPage(),
      ),
    ),

    // =========== SPLASH ===========
    GoRoute(
      path: AppRoutes.splash,
      name: 'Splash',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const SplashPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),

    // =========== AUTHENTICATION FLOW ===========
    GoRoute(
      path: '${AppRoutes.login}/:userType',
      name: 'Login',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: LoginPage(userType: state.pathParameters['userType'] ?? 'user'),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.driverRegistration,
      name: 'Driver Registration',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const RegistrationPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: AppRoutes.clientRegistration,
      name: 'Client Registration',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const RegistrationPage(userRole: UserRole.client),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'Forgot Password',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const ForgotPasswordPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: '${AppRoutes.verifyOtp}/:phoneNumber',
      name: 'Verify OTP',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: VerifyOtpPage(
          phoneNumber: state.pathParameters['phoneNumber'] ?? '',
          purpose: state.extra as VerifyPurpose? ?? VerifyPurpose.registration,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: '${AppRoutes.newPassword}/:phoneNumber/:otp',
      name: 'New Password',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: NewPasswordPage(
          phoneNumber: state.pathParameters['phoneNumber'] ?? '',
          otp: state.pathParameters['otp'] ?? '',
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),

    // =========== MAIN APP ROUTES ===========
    GoRoute(
      path: AppRoutes.home,
      name: 'Home',
      pageBuilder: (context, state) =>
          NoTransitionPage<void>(key: state.pageKey, child: const HomePage()),
    ),

    // =========== PRODUCTS ROUTES ===========
    GoRoute(
      path: '${AppRoutes.productDetails}/:id',
      name: 'Product Details',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: ProductDetailsPage(productId: state.pathParameters['id'] ?? ''),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: '${AppRoutes.categoryProducts}/:categoryId',
      name: 'Category Products',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: CategoryProductsPage(
          categoryId: int.tryParse(
                state.pathParameters['categoryId'] ?? '',
              ) ??
              0,
          categoryName: state.uri.queryParameters['name'] ?? '',
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: AppRoutes.cart,
      name: 'Cart',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const CartPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),

    // =========== ORDERS ROUTES ===========
    GoRoute(
      path: AppRoutes.orders,
      name: 'Orders',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const OrdersPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: AppRoutes.currentOrders,
      name: 'Current Orders',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const CurrentOrdersPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: AppRoutes.finishedOrders,
      name: 'Finished Orders',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const FinishedOrdersPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: AppRoutes.pendingOrderDetails,
      name: 'Order Details',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: BlocProvider(
          create: (context) => OrderDetailsCubit(
            getOrderDetailsUseCase: sl<GetOrderDetailsUseCase>(),
            acceptOrderUseCase: sl<AcceptOrderUseCase>(),
            refuseOrderUseCase: sl<RefuseOrderUseCase>(),
            startDeliveringOrderUseCase: sl<StartDeliveringOrderUseCase>(),
            finishOrderUseCase: sl<FinishOrderUseCase>(),
            initialOrder: state.extra as OrderEntity,
          ),
          child: PendingOrderDetailsPage(order: state.extra as OrderEntity),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: '${AppRoutes.clientOrderDetails}/:orderId',
      name: 'Client Order Details',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: ClientOrderDetailsPage(
          orderId: state.pathParameters['orderId'] ?? '',
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),

    // =========== SETTINGS & INFO ===========
    GoRoute(
      path: AppRoutes.profile,
      name: 'Profile',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const ProfilePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: AppRoutes.account,
      name: 'Account',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const AccountPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      name: 'Notifications',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const NotificationsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: AppRoutes.faq,
      name: 'FAQ',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const FaqPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: AppRoutes.privacy,
      name: 'Privacy',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const PrivacyPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: AppRoutes.contact,
      name: 'Contact',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const ContactPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: AppRoutes.aboutApp,
      name: 'About App',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const AboutAppPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: AppRoutes.language,
      name: 'Language',
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const LanguagePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _rtlAwareSlideTransition(
              context: context,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
      ),
    ),
  ],
);

/// Helper class to convert a Stream into a Listenable for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
