# Thimar App — Full Project Documentation

> **Root:** `C:\growfit\thimar`  
> **Platform:** Flutter (Dart SDK `^3.11.5`)  
> **App Type:** Multi-vendor delivery platform (Talabat/Mrsool-style)  
> **Roles:** `client` (end user) — `driver` (delivery person)

---

## 1. Core Stack

| Concern | Package | Usage |
|---|---|---|
| State management | `flutter_bloc` + `equatable` | Blocs/Cubits per feature |
| DI | `get_it` | `sl<Type>()` — registered in `injection.dart` |
| Routing | `go_router` | Centralized in `app_router.dart`, auth guard, RTL transitions |
| Networking | `dio` + `pretty_dio_logger` | `ApiService` wrapper, `DioClient` for interceptors |
| Cache | `hive` + `hive_flutter` | `HiveCacheService` for token/user data |
| Localization | `easy_localization` | Arabic-first (`ar`), fallback `en`, JSON files in `assets/translations/` |
| Responsive | `flutter_screenutil` | `ScreenUtilInit` with `375×812` design size |
| Maps | `google_maps_flutter` + `geolocator` + `geocoding` | Location picking in auth + delivery |
| Images | `flutter_svg`, `image_picker` | SVG rendering + camera/gallery upload |
| Utils | `carousel_slider`, `shared_preferences`, `cupertino_icons` | Sliders, prefs, iOS icons |

---

## 2. Project Structure

```
thimar/
├── assets/
│   └── translations/
│       ├── ar.json
│       └── en.json
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── cache/          # HiveService, CacheService, keys/constants
│   │   ├── config/         # MapConfig (Google Maps)
│   │   ├── constants/      # AppAssets
│   │   ├── errors/         # Failures (ServerFailure, NetworkFailure), Exceptions
│   │   ├── extensions/     # Context extensions (showSnackBar, etc.)
│   │   ├── imports/        # Barrel files (core_imports, packages_imports)
│   │   ├── injection/      # get_it registration (503 lines)
│   │   ├── models/         # UserRole enum (client/driver)
│   │   ├── networking/     # DioClient, ApiService, Endpoints, DriverEndpoints
│   │   ├── routing/        # AppRoutes, goRouter, navigation_extensions
│   │   ├── services/       # TabNavigationService, ScreenTrackerService
│   │   ├── shared/widgets/ # AppButton, AppImage, AppCard, etc.
│   │   ├── theme/          # AppTheme (green #4C8613, tajawal font)
│   │   └── usecases/       # NoParams base class
│   ├── features/
│   │   ├── about_app/      # About the app (cubit)
│   │   ├── account/        # Account page, profile, logout, language
│   │   ├── auth/           # Login, register, OTP, forgot/reset password
│   │   ├── car_models/     # Car models list (driver registration)
│   │   ├── contact/        # Contact us form
│   │   ├── faq/            # FAQ list
│   │   ├── favorites/      # Favorites page
│   │   ├── home/           # Home (products, categories, cart, search, rates)
│   │   ├── notifications/  # Notifications list
│   │   ├── orders/         # Driver + Client orders (the biggest feature)
│   │   ├── privacy/        # Privacy policy
│   │   ├── products/       # Cart, product details, category products
│   │   ├── profile/        # Driver profile edit
│   │   ├── splash/         # Splash screen
│   │   ├── transaction_history/  # Client transaction history
│   │   └── wallet/         # Wallet (balance, charge, cashout, transactions)
│   └── presentation/
│       └── onboarding/     # Role selection page
```

---

## 3. Architecture Pattern

**Feature-first Clean Architecture** — every feature has up to 3 layers:

```
lib/features/<feature>/
├── data/
│   ├── datasources/       # Remote (API) + Local (Hive) data sources
│   ├── models/            # JSON-serializable models (fromJson/toJson)
│   └── repositories/      # Repository implementations (impl)
├── domain/
│   ├── entities/          # Pure Dart domain objects (Equatable)
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Single-responsibility use cases
└── presentation/
    ├── bloc/              # Bloc/Cubit + Events + States
    ├── pages/             # Full-page widgets (StatefulWidget)
    └── widgets/           # Reusable sub-widgets
```

**Data flow:**  
`UI (BlocBuilder)` → `Bloc/Cubit` → `UseCase` → `Repository` → `DataSource` → API  
Errors: `ServerException` / `NetworkException` → `ServerFailure` / `NetworkFailure` → `Either<Failure, T>`

---

## 4. API Layer

**Base URL:** `https://thimar.amr.aait-d.com/api/`

### Client Endpoints (`lib/core/networking/endpoints.dart`)

| Category | Key Endpoints |
|---|---|
| **Auth** | `login`, `verify`, `forget_password`, `reset_password`, `resend_code`, `check_code`, `logout`, `edit_password` |
| **Products** | `products`, `search`, `sliders`, `products/{id}`, `products/{id}/rates` |
| **Favorites** | `client/products/favorites`, `client/products/{id}/add_to_favorite`, `client/products/{id}/remove_from_favorite` |
| **Client Orders** | `client/orders`, `client/orders/current`, `client/orders/finished`, `client/orders/delivery_cost`, `client/orders/{id}`, `client/orders/{id}/products` |
| **Cart** | `client/cart`, `client/cart/{id}`, `client/cart/delete_item/{id}`, `client/cart/apply_coupon` |
| **Profile** | `client/profile` |
| **Categories** | `categories`, `categories/{id}` |
| **Wallet** | `wallet`, `wallet/charge`, `wallet/cashout`, `wallet/get_wallet_transactions` |
| **Other** | `notifications`, `policy`, `about`, `terms`, `faqs`, `contact`, `cities`, `car_models`, `delete_account` |

### Driver Endpoints (`lib/core/networking/driver_endpoints.dart`)

| Category | Key Endpoints |
|---|---|
| **Orders** | `driver/orders`, `driver/pending_orders`, `driver/current_orders`, `driver/finished_orders`, `driver/refuse_order`, `driver/accept_order`, `driver/start_delivering_order`, `driver/finish_order` |
| **Auth** | `driver_register` |
| **Profile** | `driver/profile` |
| **Search** | `driver/search`, `driver/search_current` |

### Auth Token
- Stored in Hive (`user_box` → `token`)
- Attached by `DioClient` interceptor
- 401 → clears token + triggers `GoRouter` redirect to login

---

## 5. Routing (`lib/core/routing/app_router.dart`)

**Route paths** (managed by `AppRoutes` class):

| Path | Page | Notes |
|---|---|---|
| `/splash` | `SplashPage` | Fade transition |
| `/role-selection` | `RoleSelectionPage` | No transition |
| `/login/:userType` | `LoginPage` | `userType` = `client` / `driver` |
| `/driver-registration` | `RegistrationPage` | Driver multi-step form |
| `/client-registration` | `RegistrationPage(role: client)` | |
| `/forgot-password` | `ForgotPasswordPage` | |
| `/verify-otp/:phone` | `VerifyOtpPage` | |
| `/new-password/:phone/:otp` | `NewPasswordPage` | |
| `/` | `HomePage` | No transition (shell root) |
| `/profile` | `ProfilePage` | Driver profile edit |
| `/account` | `AccountPage` | Menu + settings |
| `/notifications` | `NotificationsPage` | |
| `/product-details/:id` | `ProductDetailsPage` | |
| `/category-products/:catId` | `CategoryProductsPage` | |
| `/cart` | `CartPage` | |
| `/orders` | `OrdersPage` | |
| `/current-orders` | `CurrentOrdersPage` | |
| `/finished-orders` | `FinishedOrdersPage` | |
| `/pending-order-details` | `PendingOrderDetailsPage` | BlocProvider for OrderDetailsCubit |
| `/client-order-details/:id` | `ClientOrderDetailsPage` | |
| `/wallet` | `WalletPage` | BlocProvider for WalletBloc |
| `/faq` | `FaqPage` | |
| `/privacy` | `PrivacyPage` | |
| `/contact` | `ContactPage` | |
| `/about-app` | `AboutAppPage` | |
| `/language` | `LanguagePage` | |

**Auth guard:**  
- Public routes (splash, login, registration, forgot-password) → no auth needed
- Protected routes (all others) → redirect to `/login` if no valid token
- On 401 → `DioClient.onUnauthorized` stream → `GoRouter` rebuild → redirect to login

**Transitions:**  
RTL-aware slide transitions (slide from right for Arabic, left for English).

---

## 6. DI Registration (`lib/core/injection/injection.dart`)

All registrations follow this pattern:

```dart
// Data Source
sl.registerLazySingleton<XxxRemoteDataSource>(() => XxxRemoteDataSourceImpl(sl<ApiService>()));
// Repository
sl.registerLazySingleton<XxxRepository>(() => XxxRepositoryImpl(sl<XxxRemoteDataSource>()));
// Use Cases
sl.registerLazySingleton<XxxUseCase>(() => XxxUseCase(sl<XxxRepository>()));
// Bloc
sl.registerFactory<XxxBloc>(() => XxxBloc(sl<XxxUseCase>()));
```

### Registered features (in order):
1. **Core:** `SharedPreferences`, `HiveService`, `HiveCacheService`, `Dio`, `DioClient`, `ApiService`
2. **Auth:** DataSource → Repository → LoginUseCase, DriverRegisterUseCase, VerifyAccountUseCase, ForgotPasswordUseCase, ResendCodeUseCase, ResetPasswordUseCase → AuthBloc
3. **Orders (Driver):** RemoteDataSource → Repository → GetPending/Current/FinishedOrdersUseCase, SearchCurrent/FinishedOrdersUseCase, RefuseOrderUseCase, GetOrderDetailsUseCase, AcceptOrderUseCase, StartDeliveringOrderUseCase, FinishOrderUseCase → OrdersBloc
4. **Orders (Client):** RemoteDataSource → Repository → GetClientCurrent/FinishedOrdersUseCase, GetClientOrderDetailsUseCase, StoreOrderUseCase, GetDeliveryCostUseCase, GetAllOrdersUseCase, GetOrderProductsUseCase, DeleteClientOrderUseCase → ClientOrdersBloc
5. **Home:** RemoteDataSource → Repository → GetProductsUseCase, SearchProductsUseCase, GetSlidersUseCase, ToggleFavoriteUseCase, GetFavoriteIdsUseCase, GetProductRatesUseCase, AddProductRateUseCase, GetCategoriesUseCase, GetCategoryProductsUseCase, GetCartUseCase, AddToCartUseCase, DeleteCartItemUseCase, UpdateCartItemUseCase, ApplyCouponUseCase → HomeBloc (factory param: UserRole)
6. **Transaction History:** RemoteDataSource → Repository → GetTransactionHistoryUseCase, GetTransactionHistoryByTypeUseCase, GetTransactionDetailsUseCase → TransactionHistoryBloc
7. **Wallet:** RemoteDataSource → Repository → ChargeWalletUseCase, GetWalletBalanceUseCase, GetWalletTransactionsUseCase, CashoutWalletUseCase → WalletBloc
8. **FAQ:** DataSource → Repository → GetFaqsUseCase → FaqBloc
9. **Privacy:** DataSource → Repository → GetPrivacyUseCase → PrivacyBloc
10. **Contact:** DataSource → Repository → SubmitContactUseCase → ContactBloc
11. **About App:** DataSource → Repository → GetAboutAppUseCase → AboutAppCubit
12. **Notifications:** RemoteDataSource + LocalDataSource → Repository → NotificationsBloc
13. **Account:** LocalDataSource + RemoteDataSource → Repository → GetUserProfileUseCase, UpdateDriverProfileUseCase, LogoutUseCase → AccountBloc
14. **Car Models:** DataSource → Repository → GetCarModelsUseCase → CarModelsBloc
15. **Driver Profile** → DriverProfileCubit
16. **Splash** → SplashBloc

---

## 7. Features — Detailed Breakdown

### 7.1 Auth (`lib/features/auth/`)
- **Pages:** `LoginPage`, `ForgotPasswordPage`, `VerifyOtpPage`, `NewPasswordPage`, `RegistrationPage` (driver)
- **Bloc:** `AuthBloc` — login, register (driver), verify OTP, forgot/reset password, resend code
- **Widgets (53 files total):** `UsernameField`, `PhoneField`, `PasswordField`, `OtpInputRow`, `LocationPickerField`, `ImageUploadField`, `VehicleDataForm`, `BankNameField`, `IbanField`, etc.
- **Flow:** Login → OTP verify → Reset password. Driver registration is multi-step with vehicle info, bank details, documents upload.
- **Note:** Client registration (`registerUseCase: null` in AuthBloc) — may be disabled in favor of other flow.

### 7.2 Home (`lib/features/home/`)
- **Page:** `HomePage`
- **Bloc:** `HomeBloc` — loads products, sliders, categories, favorites; handles search, search suggestions
- **Use Cases:** `GetProductsUseCase`, `GetSlidersUseCase`, `GetCategoriesUseCase`, `SearchProductsUseCase`, `ToggleFavoriteUseCase`, `GetFavoriteIdsUseCase`, `GetProductRatesUseCase`, `AddProductRateUseCase`
- **Widgets:** `HomeTopHeader`, `PromoBannerSection`, `CategoriesSection`, `SearchField`, `EmptySearchState`, `DriverHomeTab`, `DriverOrderCard`, `CartBadgeIcon`

### 7.3 Cart (`lib/features/products/presentation/pages/cart_page.dart`)
- **Use Cases:** `GetCartUseCase`, `UpdateCartItemUseCase`, `DeleteCartItemUseCase`, `ApplyCouponUseCase`
- **Flow:** List items with quantity controls → Coupon input → Summary → "إتمام الطلب" button (currently navigates to home)
- **CartItemEntity:** `id`, `title`, `image`, `price`, `amount`

### 7.4 Orders (`lib/features/orders/`) — the largest feature
#### Driver Side:
- **Blocs:** `OrdersBloc` (list management), `OrderDetailsCubit` (single order actions)
- **Pages:** `OrdersPage` (tabs: pending/current/finished), `CurrentOrdersPage`, `FinishedOrdersPage`, `PendingOrderDetailsPage`
- **Driver actions:** Accept order, Reject order, Start delivering, Finish order (with payment)
- **Search:** `SearchCurrentOrdersUseCase`, `SearchFinishedOrdersUseCase`, `SearchOrdersUseCase`

#### Client Side:
- **Bloc:** `ClientOrdersBloc`
- **Pages:** `ClientOrderDetailsPage`, `CompleteOrderPage`
- **Use Cases:** `GetClientCurrentOrdersUseCase`, `GetClientFinishedOrdersUseCase`, `GetClientOrderDetailsUseCase`, `StoreOrderUseCase`, `GetDeliveryCostUseCase`, `DeleteClientOrderUseCase`, `GetOrderProductsUseCase`

#### Shared Entities:
- **OrderEntity:** `id`, `dateKey`, `total`, `status` (pendingApproval/preparing/onWay/delivered/cancelled), `productImagePaths`, `productNames`, `customerName`, `phoneNumber`, `address`, `deliveryDate`, `deliveryTime`, `notes`, `paymentMethod`, `productsTotal`, `deliveryPrice`, `discount`, `clientImage`
- **OrderStatus enum:** `pendingApproval` → `preparing` → `onWay` → `delivered` / `cancelled`

#### Shared Widgets:
`OrderCard`, `OrderInfoHeader`, `OrderSummaryCard`, `DeliveryTimeSection`, `DeliveryAddressSection`, `NotesDisplaySection`, `NotesInputSection`, `PaymentMethodSection`, `PaymentMethodCard`, `AddressPickerSection`, `DeliveryTimePickerSection`, `TimePickerCard`, `ProductCarouselSection`, `OrderActionButton`, `OrderStatusBadge`, `CancelOrderDialog`, `OrderSuccessDialog`, `PaymentConfirmationDialog`

### 7.5 Account (`lib/features/account/`)
- **Page:** `AccountPage` — profile header + menu items (language, notifications, privacy, contact, about, logout, wallet)
- **Bloc:** `AccountBloc` — load profile, update driver profile, logout
- **Widgets:** `ProfileHeader`, `MenuItemsSection`, `LogoutDialog`
- **Sub-page:** `LanguagePage` (toggle between ar/en)

### 7.6 Wallet (`lib/features/wallet/`)
- **Page:** `WalletPage` — balance card + charge sheet + cashout sheet + transactions list
- **Bloc:** `WalletBloc` — load balance + transactions in parallel, charge, cashout, clear messages
- **Use Cases:** `GetWalletBalanceUseCase`, `GetWalletTransactionsUseCase`, `ChargeWalletUseCase`, `CashoutWalletUseCase`
- **Entity:** `WalletTransactionEntity`

### 7.7 Profile (`lib/features/profile/`)
- **Page:** `ProfilePage` — edit driver profile (name, email, phone, vehicle info, bank details)
- **Cubit:** `DriverProfileCubit`
- **Widgets:** `ProfileHeaderInfo`, `ProfileAvatar`, `ProfileField`, `ProfilePhoneField`, `ProfileSaveButton`, `DriverProfileSuccessDialog`

### 7.8 Notifications (`lib/features/notifications/`)
- **Page:** `NotificationsPage`
- **Bloc:** `NotificationsBloc` — load + mark as read
- **Data sources:** Remote (API) + Local (Hive) for offline caching
- **Widgets:** `NotificationCard`

### 7.9 Transaction History (`lib/features/transaction_history/`)
- **Page:** `TransactionHistoryPage`
- **Bloc:** `TransactionHistoryBloc` — load history, filter by type, load details
- **Widgets:** `HistoryTransactionItem`, `ProductThumbnailsRow`, `HistoryEmptyState`
- **Entity:** `TransactionEntity` (order transaction info)

### 7.10 Static Pages
- **FAQ** (`lib/features/faq/`) — `FaqPage` + `FaqBloc` + FAQ list from API
- **Privacy** (`lib/features/privacy/`) — `PrivacyPage` + `PrivacyBloc` + policy from API
- **Contact** (`lib/features/contact/`) — `ContactPage` + options (call/WhatsApp) + form
- **About App** (`lib/features/about_app/`) — `AboutAppPage` + `AboutAppCubit`
- **Car Models** (`lib/features/car_models/`) — `CarModelsBloc` + list from API (used in driver registration)

### 7.11 Other
- **Splash** (`lib/features/splash/`) — `SplashPage` + `SplashBloc` (check auth → route to home or login)
- **Onboarding** (`lib/presentation/onboarding/`) — `RoleSelectionPage` (pick client or driver)
- **Favorites** (`lib/features/favorites/`) — `FavoritesPage` (separate from home favorites toggle)

---

## 8. Caching (Hive)

| Box | Contents |
|---|---|
| `user_box` | `token`, `user`, `user_type`, `user_id`, `profile_image_path`, vehicle fields, `vehicle_type`, `vehicle_model`, `iban`, `bank_name`, driver docs |
| `app_box` | General app data |
| `settings_box` | Settings data |
| `addresses_box` | Cached addresses |

**Cache keys** (`lib/core/cache/cache_keys.dart`): `token`, `user`, `language`, `isFirstTime`, `suggestions`, `favorites`, `addresses`, `userId`, `userType`, etc.

---

## 9. Theming (`lib/core/theme/app_theme.dart`)

- **Primary:** `#4C8613` (green)
- **Secondary:** `#8BC34A`
- **Font:** `tajawal`
- **Material 3:** `useMaterial3: true`
- **Light + Dark** themes with `ColorScheme.fromSeed`

---

## 10. Shared Widgets (`lib/core/shared/widgets/`)

| Widget | Purpose |
|---|---|
| `AppBackButton` | Back navigation icon |
| `AppButton` | Styled elevated button |
| `AppSnackBar` | Success/error snackbar helper |
| `AppTextField` | Styled text field |
| `AppCard` | Styled card container |
| `AppLoading` | Centered loading spinner |
| `AppError` | Error display with retry |
| `AppEmptyState` | Empty state with icon + message |
| `AppImage` | Network image with placeholder |
| `AppSvg` | SVG asset renderer |
| `AppNavBar` | Bottom navigation bar |
| `AppSegmentedControl` | Segmented control widget |
| `AppCountryCodes` | Country code picker |
| `LanguageToggle` | Language switch widget |
| `CategoryCard` | Category display card |
| `ProductCard` | Product grid card |
| `SearchWidgets` | Search-related UI components |

---

## 11. Theme/Context Extensions

**`context_extensions.dart`:**
- `context.colorScheme` / `cs`
- `context.textTheme` / `tt`
- `context.theme`
- `context.showSnackBar(String)`
- `context.showErrorSnackBar(String)`
- `context.showSuccessSnackBar(String)`

**`navigation_extensions.dart`:**
- `context.goHome()`, `context.goCart()`, `context.goOrders()`, etc.
- `context.goPendingOrderDetails(order)`, `context.goClientOrderDetails(id)`
- `context.goWallet()`
- `context.goBack()`

**`tab_navigation_service.dart`:**
- `TabNavigationService.navigateToTab(index)` — sets `pendingTabIndex` ValueNotifier for HomePage's bottom nav

---

## 12. State Management Conventions

- Blocs use `Equatable` for states/events
- States are immutable classes with `copyWith`
- Bloc events are typed classes extending `Equatable`
- Results use `dartz` `Either<Failure, T>` pattern
- Failures: `ServerFailure(message)`, `NetworkFailure(message)`
- Exceptions: `ServerException`, `NetworkException`, `CacheException`

---

## 13. Error Flow

```
DioException
  → ApiService._handleDioError()
    → ServerException(message, statusCode) or NetworkException(message)
      → Repository catches → returns Left(ServerFailure/NetworkFailure)
        → UseCase passes through
          → Bloc receives Either → fold()
            → emit(state with error message)
              → UI shows error snackbar
```

---

## 14. Recent Git History

```
d40ca11 add apis for cart and create ui
2604f82 add apis for client profile page
6b9be69 add category section and category product page (ui and apis)
f175a50 add product details (apis and create ui)
efca87d add auth flow client and add home page products added favorite flow all of thim by (apis)
3f05d2c Add Notification system (apis)
a5ceca0 add order driver
e727411 add endpoint for edit password and add logic (apis) for profile page fix some errors in account page
a9bbaa9 fix account page
6f1e3bf first commit
```

---

## 15. Notes & Gotchas

1. **Cart → Orders flow:** Previously navigated from cart to `PendingOrderDetailsPage` with order `id: 'new'` — this caused API 404 because the page called `loadOrderDetails('new')`. Fixed by making the cart button navigate directly to home.
2. **`PendingOrderDetailsPage`** is primarily a driver-facing page (shows accept/reject/start-delivering buttons only for `_currentRole.isDriver`). For clients, it currently shows order info + products + summary only (no actions).
3. **Driver registration** is multi-step with vehicle selection, document upload (license, registration, insurance, vehicle photos), bank details (IBAN, bank name).
4. **Client registration** has `registerUseCase: null` in `AuthBloc` — possible client register is disabled or handled differently at API level.
5. **Test accounts** in `main.dart`: driver (9668479912 / 111111), client (966123456789? / 111111).
6. **Arabic-first:** `startLocale: Locale('ar')`, `fallbackLocale: Locale('ar')`. English supported.
7. **`CompleteOrderPage`** exists but is not currently routed in `app_router.dart` — might be unused/dead code.
8. **Wallet feature** was the most recent addition with full clean-architecture stack (11 files).
