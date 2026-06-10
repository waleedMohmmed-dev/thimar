import 'package:shared_preferences/shared_preferences.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/dio_client.dart';
import 'package:thimar/core/cache/hive_service.dart';
import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/core/models/user_role.dart';
import 'package:thimar/features/account/domain/usecases/update_driver_profile_use_case.dart';
import 'package:thimar/features/auth/domain/repositories/auth_repository.dart';
import 'package:thimar/features/auth/domain/usecases/login_use_case.dart';
import 'package:thimar/features/auth/domain/usecases/driver_register_use_case.dart';
import 'package:thimar/features/auth/domain/usecases/verify_account_use_case.dart';
import 'package:thimar/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:thimar/features/auth/domain/usecases/resend_code_use_case.dart';
import 'package:thimar/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:thimar/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:thimar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thimar/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:thimar/features/orders/data/datasources/client_orders_remote_data_source.dart';
import 'package:thimar/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:thimar/features/orders/data/repositories/client_orders_repository_impl.dart';
import 'package:thimar/features/orders/domain/repositories/orders_repository.dart';
import 'package:thimar/features/orders/domain/repositories/client_orders_repository.dart';
import 'package:thimar/features/orders/domain/usecases/get_pending_orders_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/get_current_orders_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/get_finished_orders_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/get_client_current_orders_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/get_client_finished_orders_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/get_client_order_details_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/store_order_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/get_delivery_cost_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/get_all_orders_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/get_order_products_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/search_current_orders_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/search_finished_orders_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/refuse_order_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/get_order_details_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/accept_order_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/start_delivering_order_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/finish_order_use_case.dart';
import 'package:thimar/features/orders/presentation/bloc/client_orders_bloc.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:thimar/features/profile/presentation/cubit/driver_profile_cubit.dart';
import 'package:thimar/features/home/data/datasources/home_remote_data_source.dart';
import 'package:thimar/features/home/data/repositories/home_repository_impl.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';
import 'package:thimar/features/home/domain/usecases/get_favorite_ids_use_case.dart';
import 'package:thimar/features/home/domain/usecases/add_product_rate_use_case.dart';
import 'package:thimar/features/home/domain/usecases/add_to_cart_use_case.dart';
import 'package:thimar/features/home/domain/usecases/apply_coupon_use_case.dart';
import 'package:thimar/features/home/domain/usecases/delete_cart_item_use_case.dart';
import 'package:thimar/features/home/domain/usecases/get_cart_use_case.dart';
import 'package:thimar/features/home/domain/usecases/get_categories_use_case.dart';
import 'package:thimar/features/home/domain/usecases/get_category_products_use_case.dart';
import 'package:thimar/features/home/domain/usecases/get_product_rates_use_case.dart';
import 'package:thimar/features/home/domain/usecases/get_products_use_case.dart';
import 'package:thimar/features/home/domain/usecases/get_sliders_use_case.dart';
import 'package:thimar/features/home/domain/usecases/search_products_use_case.dart';
import 'package:thimar/features/home/domain/usecases/toggle_favorite_use_case.dart';
import 'package:thimar/features/home/domain/usecases/update_cart_item_use_case.dart';
import 'package:thimar/features/home/presentation/bloc/home_bloc.dart';

import 'package:thimar/features/transaction_history/data/datasources/transaction_history_remote_data_source.dart';
import 'package:thimar/features/transaction_history/data/repositories/transaction_history_repository_impl.dart';
import 'package:thimar/features/transaction_history/domain/repositories/transaction_history_repository.dart';
import 'package:thimar/features/transaction_history/domain/usecases/get_transaction_history_use_case.dart';
import 'package:thimar/features/transaction_history/domain/usecases/get_transaction_history_by_type_use_case.dart';
import 'package:thimar/features/transaction_history/domain/usecases/get_transaction_details_use_case.dart';
import 'package:thimar/features/transaction_history/presentation/bloc/transaction_history_bloc.dart';
import 'package:thimar/features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'package:thimar/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:thimar/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:thimar/features/wallet/domain/usecases/get_wallet_use_case.dart';
import 'package:thimar/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:thimar/features/faq/data/datasources/faq_remote_data_source.dart';
import 'package:thimar/features/faq/data/repositories/faq_repository_impl.dart';
import 'package:thimar/features/faq/domain/repositories/faq_repository.dart';
import 'package:thimar/features/faq/domain/usecases/get_faqs_use_case.dart';
import 'package:thimar/features/faq/presentation/bloc/faq_bloc.dart';
import 'package:thimar/features/privacy/data/datasources/privacy_remote_data_source.dart';
import 'package:thimar/features/privacy/data/repositories/privacy_repository_impl.dart';
import 'package:thimar/features/privacy/domain/repositories/privacy_repository.dart';
import 'package:thimar/features/privacy/domain/usecases/get_privacy_use_case.dart';
import 'package:thimar/features/privacy/presentation/bloc/privacy_bloc.dart';
import 'package:thimar/features/contact/data/datasources/contact_remote_data_source.dart';
import 'package:thimar/features/contact/data/repositories/contact_repository_impl.dart';
import 'package:thimar/features/contact/domain/repositories/contact_repository.dart';
import 'package:thimar/features/contact/domain/usecases/submit_contact_use_case.dart';
import 'package:thimar/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:thimar/features/about_app/data/datasources/about_app_remote_data_source.dart';
import 'package:thimar/features/about_app/data/repositories/about_app_repository_impl.dart';
import 'package:thimar/features/about_app/domain/repositories/about_app_repository.dart';
import 'package:thimar/features/about_app/domain/usecases/get_about_app_use_case.dart';
import 'package:thimar/features/about_app/presentation/cubit/about_app_cubit.dart';
import 'package:thimar/features/account/data/datasources/account_datasource.dart';
import 'package:thimar/features/account/data/datasources/account_remote_data_source.dart';
import 'package:thimar/features/account/data/repositories/account_repository_impl.dart';
import 'package:thimar/features/account/domain/repositories/account_repository.dart';
import 'package:thimar/features/account/domain/usecases/get_user_profile_usecase.dart';
import 'package:thimar/features/notifications/data/datasources/notifications_local_data_source.dart';
import 'package:thimar/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:thimar/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:thimar/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:thimar/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:thimar/features/account/domain/usecases/logout_usecase.dart';
import 'package:thimar/features/account/presentation/bloc/account_bloc.dart';
import 'package:thimar/features/car_models/data/datasources/car_models_remote_data_source.dart';
import 'package:thimar/features/car_models/data/repositories/car_models_repository_impl.dart';
import 'package:thimar/features/car_models/domain/repositories/car_models_repository.dart';
import 'package:thimar/features/car_models/domain/usecases/get_car_models_use_case.dart';
import 'package:thimar/features/car_models/presentation/bloc/car_models_bloc.dart';

import 'package:thimar/features/splash/presentation/bloc/splash_bloc.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  // Core Services & External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // Hive Cache Layer
  final hiveService = HiveService();
  await hiveService.init();
  sl.registerLazySingleton<HiveService>(() => hiveService);
  sl.registerLazySingleton<HiveCacheService>(
    () => HiveCacheService(sl<HiveService>()),
  );

  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<DioClient>(
    () => DioClient(sl<Dio>(), sl<HiveCacheService>()),
  );
  sl.registerLazySingleton<ApiService>(() => ApiService(sl<DioClient>()));

  // --- Auth Feature ---
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiService>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () =>
        AuthRepositoryImpl(sl<AuthRemoteDataSource>(), sl<HiveCacheService>()),
  );
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<DriverRegisterUseCase>(
    () => DriverRegisterUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<VerifyAccountUseCase>(
    () => VerifyAccountUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ResendCodeUseCase>(
    () => ResendCodeUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: null, // Client register disabled
      driverRegisterUseCase: sl<DriverRegisterUseCase>(),
      verifyAccountUseCase: sl<VerifyAccountUseCase>(),
      forgotPasswordUseCase: sl<ForgotPasswordUseCase>(),
      resendCodeUseCase: sl<ResendCodeUseCase>(),
      resetPasswordUseCase: sl<ResetPasswordUseCase>(),
    ),
  );

  // --- Orders Feature (Driver) ---
  sl.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(sl<ApiService>()),
  );
  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(sl<OrdersRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetPendingOrdersUseCase>(
    () => GetPendingOrdersUseCase(sl<OrdersRepository>()),
  );
  sl.registerLazySingleton<GetCurrentOrdersUseCase>(
    () => GetCurrentOrdersUseCase(sl<OrdersRepository>()),
  );
  sl.registerLazySingleton<GetFinishedOrdersUseCase>(
    () => GetFinishedOrdersUseCase(sl<OrdersRepository>()),
  );
  sl.registerLazySingleton<SearchCurrentOrdersUseCase>(
    () => SearchCurrentOrdersUseCase(sl<OrdersRepository>()),
  );
  sl.registerLazySingleton<SearchFinishedOrdersUseCase>(
    () => SearchFinishedOrdersUseCase(sl<OrdersRepository>()),
  );
  sl.registerLazySingleton<RefuseOrderUseCase>(
    () => RefuseOrderUseCase(sl<OrdersRepository>()),
  );
  sl.registerLazySingleton<GetOrderDetailsUseCase>(
    () => GetOrderDetailsUseCase(sl<OrdersRepository>()),
  );
  sl.registerLazySingleton<AcceptOrderUseCase>(
    () => AcceptOrderUseCase(sl<OrdersRepository>()),
  );
  sl.registerLazySingleton<StartDeliveringOrderUseCase>(
    () => StartDeliveringOrderUseCase(sl<OrdersRepository>()),
  );
  sl.registerLazySingleton<FinishOrderUseCase>(
    () => FinishOrderUseCase(sl<OrdersRepository>()),
  );
  sl.registerFactory<OrdersBloc>(
    () => OrdersBloc(
      getPendingOrdersUseCase: sl<GetPendingOrdersUseCase>(),
      getCurrentOrdersUseCase: sl<GetCurrentOrdersUseCase>(),
      getFinishedOrdersUseCase: sl<GetFinishedOrdersUseCase>(),
      searchCurrentOrdersUseCase: sl<SearchCurrentOrdersUseCase>(),
      searchFinishedOrdersUseCase: sl<SearchFinishedOrdersUseCase>(),
      refuseOrderUseCase: sl<RefuseOrderUseCase>(),
    ),
  );

  // --- Orders Feature (Client) ---
  sl.registerLazySingleton<ClientOrdersRemoteDataSource>(
    () => ClientOrdersRemoteDataSourceImpl(sl<ApiService>()),
  );
  sl.registerLazySingleton<ClientOrdersRepository>(
    () => ClientOrdersRepositoryImpl(sl<ClientOrdersRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetClientCurrentOrdersUseCase>(
    () => GetClientCurrentOrdersUseCase(sl<ClientOrdersRepository>()),
  );
  sl.registerLazySingleton<GetClientFinishedOrdersUseCase>(
    () => GetClientFinishedOrdersUseCase(sl<ClientOrdersRepository>()),
  );
  sl.registerLazySingleton<GetClientOrderDetailsUseCase>(
    () => GetClientOrderDetailsUseCase(sl<ClientOrdersRepository>()),
  );
  sl.registerLazySingleton<StoreOrderUseCase>(
    () => StoreOrderUseCase(sl<ClientOrdersRepository>()),
  );
  sl.registerLazySingleton<GetDeliveryCostUseCase>(
    () => GetDeliveryCostUseCase(sl<ClientOrdersRepository>()),
  );
  sl.registerLazySingleton<GetAllOrdersUseCase>(
    () => GetAllOrdersUseCase(sl<ClientOrdersRepository>()),
  );
  sl.registerLazySingleton<GetOrderProductsUseCase>(
    () => GetOrderProductsUseCase(sl<ClientOrdersRepository>()),
  );
  sl.registerFactory<ClientOrdersBloc>(
    () => ClientOrdersBloc(
      getClientCurrentOrdersUseCase: sl<GetClientCurrentOrdersUseCase>(),
      getClientFinishedOrdersUseCase: sl<GetClientFinishedOrdersUseCase>(),
    ),
  );

  // --- Home Feature ---
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl<ApiService>()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(sl<HomeRepository>()),
  );
  sl.registerLazySingleton<SearchProductsUseCase>(
    () => SearchProductsUseCase(sl<HomeRepository>()),
  );
  sl.registerLazySingleton<GetSlidersUseCase>(
    () => GetSlidersUseCase(sl<HomeRepository>()),
  );
  sl.registerLazySingleton<ToggleFavoriteUseCase>(
    () => ToggleFavoriteUseCase(sl<HomeRepository>()),
  );
  sl.registerLazySingleton<GetFavoriteIdsUseCase>(
    () => GetFavoriteIdsUseCase(sl<HomeRepository>()),
  );
  sl.registerLazySingleton<GetProductRatesUseCase>(
    () => GetProductRatesUseCase(sl<HomeRepository>()),
  );
  sl.registerLazySingleton<AddProductRateUseCase>(
    () => AddProductRateUseCase(sl<HomeRepository>()),
  );
  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(sl<HomeRepository>()),
  );
  sl.registerLazySingleton<GetCategoryProductsUseCase>(
    () => GetCategoryProductsUseCase(sl<HomeRepository>()),
  );
  sl.registerLazySingleton<GetCartUseCase>(
    () => GetCartUseCase(sl<HomeRepository>()),
  );
  sl.registerLazySingleton<AddToCartUseCase>(
    () => AddToCartUseCase(sl<HomeRepository>()),
  );
  sl.registerLazySingleton<DeleteCartItemUseCase>(
    () => DeleteCartItemUseCase(sl<HomeRepository>()),
  );
  sl.registerLazySingleton<UpdateCartItemUseCase>(
    () => UpdateCartItemUseCase(sl<HomeRepository>()),
  );
  sl.registerLazySingleton<ApplyCouponUseCase>(
    () => ApplyCouponUseCase(sl<HomeRepository>()),
  );
  sl.registerFactoryParam<HomeBloc, UserRole, void>(
    (role, _) => HomeBloc(
      getProductsUseCase: sl<GetProductsUseCase>(),
      searchProductsUseCase: sl<SearchProductsUseCase>(),
      getSlidersUseCase: sl<GetSlidersUseCase>(),
      toggleFavoriteUseCase: sl<ToggleFavoriteUseCase>(),
      getFavoriteIdsUseCase: sl<GetFavoriteIdsUseCase>(),
      role: role,
    ),
  );

  // --- Transaction History Feature ---
  sl.registerLazySingleton<TransactionHistoryRemoteDataSource>(
    () => TransactionHistoryRemoteDataSourceImpl(sl<ApiService>()),
  );
  sl.registerLazySingleton<TransactionHistoryRepository>(
    () => TransactionHistoryRepositoryImpl(
      remoteDataSource: sl<TransactionHistoryRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<GetTransactionHistoryUseCase>(
    () => GetTransactionHistoryUseCase(sl<TransactionHistoryRepository>()),
  );
  sl.registerLazySingleton<GetTransactionHistoryByTypeUseCase>(
    () =>
        GetTransactionHistoryByTypeUseCase(sl<TransactionHistoryRepository>()),
  );
  sl.registerLazySingleton<GetTransactionDetailsUseCase>(
    () => GetTransactionDetailsUseCase(sl<TransactionHistoryRepository>()),
  );
  sl.registerFactory<TransactionHistoryBloc>(
    () => TransactionHistoryBloc(
      getTransactionHistoryUseCase: sl<GetTransactionHistoryUseCase>(),
    ),
  );

  // --- Wallet Feature ---
  sl.registerLazySingleton<WalletRemoteDataSource>(
    () => WalletRemoteDataSourceImpl(sl<ApiService>()),
  );
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(sl<WalletRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetWalletUseCase>(
    () => GetWalletUseCase(sl<WalletRepository>()),
  );
  sl.registerFactory<WalletBloc>(
    () => WalletBloc(getWalletUseCase: sl<GetWalletUseCase>()),
  );

  // --- FAQ Feature ---
  sl.registerLazySingleton<FaqRemoteDataSource>(
    () => FaqRemoteDataSourceImpl(sl<ApiService>()),
  );
  sl.registerLazySingleton<FaqRepository>(
    () => FaqRepositoryImpl(sl<FaqRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetFaqsUseCase>(
    () => GetFaqsUseCase(sl<FaqRepository>()),
  );
  sl.registerFactory<FaqBloc>(() => FaqBloc(sl<GetFaqsUseCase>()));

  // --- Privacy Feature ---
  sl.registerLazySingleton<PrivacyRemoteDataSource>(
    () => PrivacyRemoteDataSourceImpl(sl<ApiService>()),
  );
  sl.registerLazySingleton<PrivacyRepository>(
    () => PrivacyRepositoryImpl(sl<PrivacyRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetPrivacyUseCase>(
    () => GetPrivacyUseCase(sl<PrivacyRepository>()),
  );
  sl.registerFactory<PrivacyBloc>(() => PrivacyBloc(sl<GetPrivacyUseCase>()));

  // --- Contact Feature ---
  sl.registerLazySingleton<ContactRemoteDataSource>(
    () => ContactRemoteDataSourceImpl(sl<ApiService>()),
  );
  sl.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(sl<ContactRemoteDataSource>()),
  );
  sl.registerLazySingleton<SubmitContactUseCase>(
    () => SubmitContactUseCase(sl<ContactRepository>()),
  );
  sl.registerFactory<ContactBloc>(
    () => ContactBloc(sl<SubmitContactUseCase>()),
  );

  // --- About App Feature ---
  sl.registerLazySingleton<AboutAppRemoteDataSource>(
    () => AboutAppRemoteDataSourceImpl(sl<ApiService>()),
  );
  sl.registerLazySingleton<AboutAppRepository>(
    () => AboutAppRepositoryImpl(sl<AboutAppRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetAboutAppUseCase>(
    () => GetAboutAppUseCase(sl<AboutAppRepository>()),
  );
  sl.registerFactory<AboutAppCubit>(
    () => AboutAppCubit(sl<GetAboutAppUseCase>()),
  );

  // --- Notifications Feature ---
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(sl<ApiService>()),
  );
  sl.registerLazySingleton<NotificationsLocalDataSource>(
    () => NotificationsLocalDataSource(),
  );
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(
      sl<NotificationsRemoteDataSource>(),
      sl<NotificationsLocalDataSource>(),
    ),
  );
  sl.registerFactory<NotificationsBloc>(
    () => NotificationsBloc(
      notificationsRepository: sl<NotificationsRepository>(),
    ),
  );

  // --- Account Feature ---
  sl.registerLazySingleton<AccountDataSource>(
    () => AccountDataSourceImpl(sl<HiveCacheService>()),
  );
  sl.registerLazySingleton<AccountRemoteDataSource>(
    () => AccountRemoteDataSourceImpl(sl<ApiService>(), sl<HiveCacheService>()),
  );
  sl.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      dataSource: sl<AccountDataSource>(),
      remoteDataSource: sl<AccountRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(sl<AccountRepository>()),
  );
  sl.registerLazySingleton<UpdateDriverProfileUseCase>(
    () => UpdateDriverProfileUseCase(sl<AccountRepository>()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl<AccountRepository>()),
  );
  sl.registerFactory<AccountBloc>(() {
    return AccountBloc(
      getUserProfileUseCase: sl<GetUserProfileUseCase>(),
      updateDriverProfileUseCase: sl<UpdateDriverProfileUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      accountRepository: sl<AccountRepository>(),
    );
  });

  // --- Car Models Feature ---
  sl.registerLazySingleton<CarModelsRemoteDataSource>(
    () => CarModelsRemoteDataSourceImpl(sl<ApiService>()),
  );
  sl.registerLazySingleton<CarModelsRepository>(
    () => CarModelsRepositoryImpl(sl<CarModelsRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetCarModelsUseCase>(
    () => GetCarModelsUseCase(sl<CarModelsRepository>()),
  );
  sl.registerFactory<CarModelsBloc>(
    () => CarModelsBloc(sl<GetCarModelsUseCase>()),
  );

  sl.registerFactory<DriverProfileCubit>(
    () => DriverProfileCubit(sl<ApiService>()),
  );

  // --- Splash Feature ---
  sl.registerFactory<SplashBloc>(
    () => SplashBloc(cacheService: sl<HiveCacheService>()),
  );
}
