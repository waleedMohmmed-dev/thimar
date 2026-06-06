# Flutter Codebase Audit Report - Driver/Client Separation
**Date**: June 5, 2026  
**Scope**: lib/features/orders/, lib/features/home/, lib/core/routing/, lib/core/injection/

---

## Executive Summary

The codebase demonstrates **excellent architecture for driver/client separation** with proper use of separate repositories, BLoCs, and endpoints. However, there is **1 critical issue** found: a hardcoded endpoint string that should use an Endpoints constant.

---

## Detailed Findings

### ✅ GOOD: Endpoint Definitions (Properly Separated)
**File**: `lib/core/networking/endpoints.dart`

All endpoints are correctly defined and separated:

**Driver Endpoints**:
- `driverSearch = "driver/search"`
- `driverPendingOrders = "driver/pending_orders"`
- `driverCurrentOrders = "driver/current_orders"`
- `driverFinishedOrders = "driver/finished_orders"`
- `driverRefuseOrder = "driver/refuse_order"`
- `driverAcceptOrder = "driver/accept_order"`
- `driverStartDelivering = "driver/start_delivering_order"`
- `driverFinishOrder = "driver/finish_order"`

**Client Endpoints**:
- `clientOrders = "client/orders"`
- `deliveryCost = "client/orders/delivery_cost"`

---

### ✅ GOOD: Dependency Injection (Properly Separated)
**File**: `lib/core/injection/injection.dart` (Lines 220-270)

**Driver Orders Registration**:
```dart
sl.registerLazySingleton<OrdersRemoteDataSource>(
  () => OrdersRemoteDataSourceImpl(sl<ApiService>()),
);
sl.registerLazySingleton<OrdersRepository>(
  () => OrdersRepositoryImpl(sl<OrdersRemoteDataSource>()),
);
// ... all driver order use cases
sl.registerFactory<OrdersBloc>(
  () => OrdersBloc(...),
);
```

**Client Orders Registration**:
```dart
sl.registerLazySingleton<ClientOrdersRemoteDataSource>(
  () => ClientOrdersRemoteDataSourceImpl(sl<ApiService>()),
);
sl.registerLazySingleton<ClientOrdersRepository>(
  () => ClientOrdersRepositoryImpl(sl<ClientOrdersRemoteDataSource>()),
);
sl.registerLazySingleton<GetClientOrdersUseCase>(
  () => GetClientOrdersUseCase(sl<ClientOrdersRepository>()),
);
sl.registerFactory<ClientOrdersBloc>(
  () => ClientOrdersBloc(
    getClientOrdersUseCase: sl<GetClientOrdersUseCase>(),
  ),
);
```

✅ **Verdict**: Completely separated - no cross-contamination

---

### ✅ GOOD: Data Source Separation
**Driver Orders**: `lib/features/orders/data/datasources/orders_remote_data_source.dart`
- Uses: `driverPendingOrders`, `driverCurrentOrders`, `driverFinishedOrders`, `driverRefuseOrder`, `driverAcceptOrder`, `driverStartDelivering`, `driverFinishOrder`
- Methods: `getPendingOrders()`, `getCurrentOrders()`, `getFinishedOrders()`, `searchCurrentOrders()`, `searchFinishedOrders()`, `refuseOrder()`, etc.

**Client Orders**: `lib/features/orders/data/datasources/client_orders_remote_data_source.dart`
- Uses: `clientOrders` endpoint only
- Methods: `getClientOrders()`

✅ **Verdict**: Completely separated - no cross-contamination

---

### ✅ GOOD: BLoC Separation
**Driver BLoC**: `lib/features/orders/presentation/bloc/orders_bloc.dart`
- Class: `OrdersBloc`
- Events: `OrdersStarted`, etc.
- State: `OrdersState` with fields: `status`, `pendingOrders`, `currentOrders`, `finishedOrders`, `refuseSuccessMessage`, `refuseError`, `errorMessage`
- Uses: `GetPendingOrdersUseCase`, `GetCurrentOrdersUseCase`, `GetFinishedOrdersUseCase`, `SearchCurrentOrdersUseCase`, `SearchFinishedOrdersUseCase`, `RefuseOrderUseCase`

**Client BLoC**: `lib/features/orders/presentation/bloc/client_orders_bloc.dart`
- Class: `ClientOrdersBloc`
- Events: `ClientOrdersStarted`
- State: `ClientOrdersState` with fields: `status`, `orders`
- Uses: `GetClientOrdersUseCase` only

✅ **Verdict**: Completely separate - no mixing

---

### ✅ GOOD: Home Page Role-Based Routing
**File**: `lib/features/home/presentation/pages/home_page.dart` (Lines 24-110)

```dart
final isDriver = sl<RoleService>().currentRole.isDriver;

if (isDriver) {
  return BlocProvider(
    create: (_) => sl<OrdersBloc>()..add(const OrdersStarted()),
    child: const _DriverHomeShell(),
  );
}

return BlocProvider(
  create: (_) => sl<HomeBloc>()..add(const ProductsFetched()),
  child: const _ClientHomeShell(),
);
```

**Driver View** (_DriverHomeShell):
- Tab 1: `DriverHomeTab()` - Shows pending orders
- Tab 2: `OrdersPage()` - Shows current/finished orders
- Tab 3: `NotificationsPage()`
- Tab 4: `AccountPage()`

**Client View** (_ClientHomeShell):
- Tab 1: `_HomeProductsTab()` - Shows products
- Tab 2: `ClientOrdersPage()` - Shows client orders
- Tab 3: `NotificationsPage()`
- Tab 4: `FavoritesPage()`
- Tab 5: `AccountPage()`

✅ **Verdict**: Perfect separation - drivers never see client orders, clients never see driver orders

---

### ✅ GOOD: Driver Home Components
**File 1**: `lib/features/home/presentation/widgets/driver_home_tab.dart`
- Imports: `OrdersBloc`, `OrdersEvent`, `OrdersState` ✅
- Event: `OrdersStarted()` - Correct!
- No client order imports ✅

**File 2**: `lib/features/home/presentation/widgets/driver_order_card.dart`
- Imports: `OrdersBloc`, `OrdersEvent`, `OrdersState` ✅
- No client order imports ✅
- Uses: `OrderEntity` (domain entity - shared, correct)
- No product/category imports ✅

✅ **Verdict**: Driver components use correct driver-specific BLoCs

---

### ✅ GOOD: Client Orders Page
**File**: `lib/features/orders/presentation/pages/client_orders_page.dart`
- Imports: `ClientOrdersBloc`, `ClientOrdersEvent`, `ClientOrdersState` ✅
- Event: `ClientOrdersStarted()` - Correct!
- No driver order imports ✅
- No product/category imports ✅

✅ **Verdict**: Client components use correct client-specific BLoCs

---

### ✅ GOOD: Orders Page Context Awareness
**File**: `lib/features/orders/presentation/pages/orders_page.dart`
- Smart check: `context.read<OrdersBloc?>() != null`
- If BLoC exists (from HomePage for drivers), reuses it
- If not, creates new BLoC (for standalone usage)
- Works for both driver and client contexts based on available BLoC

✅ **Verdict**: Intelligent context handling

---

### ❌ CRITICAL ISSUE: Hardcoded Endpoint String
**File**: `lib/features/orders/data/datasources/orders_remote_data_source.dart` (Line 64)

```dart
@override
Future<List<CurrentOrderSearchModel>> searchCurrentOrders(
  String keyword,
) async {
  final response = await _apiService.get(
    'driver/search_current',  // ❌ HARDCODED STRING
    params: {'keyword': keyword},
  );
  final List data = response['data'] ?? [];
  return data
      .map((json) => CurrentOrderSearchModel.fromJson(json))
      .toList();
}
```

**Problem**: Uses hardcoded string `'driver/search_current'` instead of Endpoints constant

**Correct comparison** - Next method does it right (Line 78):
```dart
@override
Future<List<CurrentOrderSearchModel>> searchFinishedOrders(
  String keyword,
) async {
  final response = await _apiService.get(
    Endpoints.driverSearch,  // ✅ USES CONSTANT
    params: {'keyword': keyword},
  );
  // ...
}
```

**Note**: The endpoint string itself is correct (`driver/search_current` is for searching current orders), but it should be defined as a constant in `Endpoints` class.

**Recommendation**:
1. Add to `lib/core/networking/endpoints.dart`:
   ```dart
   static const String driverSearchCurrent = "driver/search_current";
   ```
2. Update `lib/features/orders/data/datasources/orders_remote_data_source.dart` Line 64:
   ```dart
   final response = await _apiService.get(
     Endpoints.driverSearchCurrent,  // Use constant
     params: {'keyword': keyword},
   );
   ```

---

### ✅ GOOD: No Product/Category Imports in Driver Screens
**Checked Files**:
- `driver_home_tab.dart` ✅ No product/category imports
- `driver_order_card.dart` ✅ No product/category imports
- `orders_page.dart` ✅ No product/category imports

**Verified**: Categories section is only in `_HomeProductsTab()` (client-side only)

---

### ✅ GOOD: Routing Separation
**File**: `lib/core/routing/app_router.dart`
- Driver specific routes: `/driver-registration`, driver pages properly imported
- Orders routes properly separated for driver and client contexts
- Navigation extensions work for both contexts

✅ **Verdict**: Routing structure supports both driver and client flows

---

## Summary of All Issues Found

| # | Issue | Severity | File | Line | Status |
|---|-------|----------|------|------|--------|
| 1 | Hardcoded endpoint string `'driver/search_current'` | Critical | `orders_remote_data_source.dart` | 64 | Should use `Endpoints.driverSearchCurrent` |

---

## Summary of Good Practices Found

| # | Practice | File | Status |
|---|----------|------|--------|
| 1 | Separate driver/client repositories | `injection.dart` | ✅ Excellent |
| 2 | Separate BLoCs for orders (OrdersBloc vs ClientOrdersBloc) | `orders_bloc.dart`, `client_orders_bloc.dart` | ✅ Excellent |
| 3 | Role-based UI routing | `home_page.dart` | ✅ Excellent |
| 4 | Endpoint constants for driver endpoints | `endpoints.dart` | ✅ Good (except 1 case) |
| 5 | No cross-contamination in data sources | All data sources | ✅ Perfect |
| 6 | No product/category imports in driver screens | Driver widgets | ✅ Clean |
| 7 | Proper injection of role service | `home_page.dart` | ✅ Good |
| 8 | Context-aware BLoC usage in shared pages | `orders_page.dart` | ✅ Smart |

---

## Recommendations

### High Priority (Must Fix)
1. **Add missing endpoint constant**: Add `driverSearchCurrent = "driver/search_current"` to `Endpoints` class
2. **Update hardcoded string**: Replace `'driver/search_current'` with `Endpoints.driverSearchCurrent` in `orders_remote_data_source.dart` Line 64

### Medium Priority (Nice to Have)
1. Consider adding similar separation for client search endpoint when implemented
2. Add unit tests to verify driver/client BLoC separation
3. Add integration tests for role-based navigation switching

### Low Priority (Documentation)
1. Add code comments indicating driver-only vs client-only components
2. Document the role-based routing pattern for future developers

---

## Conclusion

**Overall Assessment**: ✅ **GOOD** - The codebase demonstrates excellent architecture for separating driver and client functionality. The separation is properly implemented at multiple levels:
- Data layer (separate data sources and repositories)
- Domain layer (separate use cases)
- Presentation layer (separate BLoCs, pages, and widgets)
- UI layer (role-based routing)

**One minor issue** (hardcoded endpoint) should be fixed for consistency with the rest of the codebase.

---

**Report Generated**: 2026-06-05  
**Auditor**: Code Analysis Agent
