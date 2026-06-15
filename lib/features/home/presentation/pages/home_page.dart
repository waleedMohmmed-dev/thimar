import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/cache/cache_constants.dart';
import 'package:thimar/core/cache/cache_keys.dart';
import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/core/models/user_role.dart';
import 'package:thimar/core/services/tab_navigation_service.dart';
import 'package:thimar/features/favorites/presentation/pages/favorites_page.dart';
import 'package:thimar/features/notifications/presentation/pages/notifications_page.dart';
import 'package:thimar/features/orders/presentation/pages/orders_page.dart';
import 'package:thimar/features/account/presentation/pages/account_page.dart';
import 'package:thimar/features/home/presentation/bloc/home_bloc.dart';
import 'package:thimar/features/home/presentation/bloc/home_event.dart';
import 'package:thimar/features/home/presentation/bloc/home_state.dart';
import 'package:thimar/features/home/presentation/widgets/driver_home_tab.dart';
import 'package:thimar/features/home/presentation/widgets/home_top_header.dart';
import 'package:thimar/features/home/presentation/widgets/promo_banner_section.dart';
import 'package:thimar/features/home/presentation/widgets/search_field.dart'
    as home_search;
import 'package:thimar/features/home/presentation/widgets/categories_section.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_event.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_state.dart';
import 'package:thimar/features/account/presentation/bloc/account_bloc.dart';
import 'package:thimar/features/account/presentation/bloc/account_event.dart';
import 'package:thimar/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:thimar/features/notifications/presentation/bloc/notifications_event.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final role = UserRole.fromString(
      sl<HiveCacheService>().get<String>(
        key: CacheKeys.userType,
        boxName: CacheConstants.userBox,
      ),
    );

    return MultiBlocProvider(
      providers: [
        if (role.isDriver)
          BlocProvider(create: (_) => sl<OrdersBloc>())
        else
          BlocProvider(
            create: (_) =>
                sl<HomeBloc>(param1: role)..add(const ProductsFetched()),
          ),
        BlocProvider(create: (_) => sl<AccountBloc>()),
        BlocProvider(create: (_) => sl<NotificationsBloc>()),
      ],
      child: _HomeShell(role: role),
    );
  }
}

class _HomeShell extends StatefulWidget {
  final UserRole role;

  const _HomeShell({required this.role});

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    TabNavigationService.pendingTabIndex.addListener(_onPendingTab);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTabData(0));
  }

  @override
  void dispose() {
    TabNavigationService.pendingTabIndex.removeListener(_onPendingTab);
    super.dispose();
  }

  void _onPendingTab() {
    final tab = TabNavigationService.pendingTabIndex.value;
    if (tab != null) {
      TabNavigationService.pendingTabIndex.value = null;
      _onTabTapped(tab);
    }
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTabData(index));
  }

  void _loadTabData(int index) {
    switch (index) {
      case 0:
        if (widget.role.isDriver) {
          context.read<OrdersBloc>().add(const PendingOrdersRequested());
        }
      case 1:
        if (widget.role.isDriver) {
          context.read<OrdersBloc>().add(const CurrentOrdersRequested());
        }
      case 2:
        if (widget.role.isDriver) {
          context.read<NotificationsBloc>().add(const NotificationsFetched());
        }
      case 3:
        if (widget.role.isDriver) {
          context.read<AccountBloc>().add(const AccountStarted());
        } else {
          context.read<NotificationsBloc>().add(const NotificationsFetched());
        }
      case 4:
        if (!widget.role.isDriver) {
          context.read<AccountBloc>().add(const AccountStarted());
        }
    }
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return widget.role.isDriver
            ? const DriverHomeTab()
            : const _ClientHomeTab();
      case 1:
        return OrdersPage(role: widget.role);
      case 2:
        return widget.role.isDriver
            ? const NotificationsPage()
            : const FavoritesPage();
      case 3:
        return widget.role.isDriver
            ? const AccountPage()
            : const NotificationsPage();
      case 4:
        return const AccountPage();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      body: SafeArea(
        child: _buildCurrentTab(),
      ),
      bottomNavigationBar: AppNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: widget.role.isDriver
            ? const [
                AppNavBarItem(labelKey: 'nav_home', icon: Icons.home_outlined),
                AppNavBarItem(
                  labelKey: 'nav_orders',
                  icon: Icons.receipt_long_outlined,
                ),
                AppNavBarItem(
                  labelKey: 'nav_notifications',
                  icon: Icons.notifications_none_outlined,
                ),
                AppNavBarItem(
                  labelKey: 'nav_account',
                  icon: Icons.person_outline,
                ),
              ]
            : const [
                AppNavBarItem(labelKey: 'nav_home', icon: Icons.home_outlined),
                AppNavBarItem(
                  labelKey: 'nav_orders',
                  icon: Icons.receipt_long_outlined,
                ),
                AppNavBarItem(
                  labelKey: 'nav_favorites',
                  icon: Icons.favorite_outline,
                ),
                AppNavBarItem(
                  labelKey: 'nav_notifications',
                  icon: Icons.notifications_none_outlined,
                ),
                AppNavBarItem(
                  labelKey: 'nav_account',
                  icon: Icons.person_outline,
                ),
              ],
      ),
    );
    if (widget.role.isDriver) {
      return BlocListener<OrdersBloc, OrdersState>(
        listenWhen: (prev, curr) => prev.homeTabIndex != curr.homeTabIndex,
        listener: (context, state) {
          if (state.homeTabIndex != null) {
            _onTabTapped(state.homeTabIndex!);
            context.read<OrdersBloc>().add(const ClearHomeTabIndex());
          }
        },
        child: scaffold,
      );
    }
    return scaffold;
  }
}

class _ClientHomeTab extends StatefulWidget {
  const _ClientHomeTab();

  @override
  State<_ClientHomeTab> createState() => _ClientHomeTabState();
}

class _ClientHomeTabState extends State<_ClientHomeTab> {
  final _searchController = TextEditingController();
  int _bannerIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final products = _searchController.text.trim().isEmpty
            ? state.products
            : state.searchResults;

        return RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(const ProductsFetched());
          },
          child: ListView(
            padding: EdgeInsets.only(bottom: 100.h),
            children: [
              const HomeTopHeader(),
              home_search.SearchField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                  context
                      .read<HomeBloc>()
                      .add(ProductsSearched(keyword: value));
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: PromoBannerSection(
                  banners: state.banners,
                  currentIndex: _bannerIndex,
                  onPageChanged: (index, _) {
                    setState(() => _bannerIndex = index);
                  },
                ),
              ),
              SizedBox(height: 24.h),
              const CategoriesSection(),
              SizedBox(height: 24.h),
              if (state.isLoading)
                SizedBox(
                  height: 240.h,
                  child: const Center(child: AppLoading()),
                )
              else if (state.errorMessage != null)
                AppError(
                  message: state.errorMessage!,
                  onRetry: () {
                    context.read<HomeBloc>().add(const ProductsFetched());
                  },
                )
              else if (products.isEmpty)
                AppEmptyState(
                  icon: Icons.shopping_basket_outlined,
                  title: 'no_products'.tr(),
                  subtitle: 'check_back_later'.tr(),
                )
              else
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14.h,
                      crossAxisSpacing: 14.w,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        isFavorite: state.favoriteIds.contains(product.id),
                        onTap: () {
                          context.push(
                            '${AppRoutes.productDetails}/${product.id}',
                          );
                        },
                        onFavoriteToggle: () {
                          context.read<HomeBloc>().add(
                            ProductFavoriteToggled(product.id),
                          );
                        },
                        onAddToCart: () {
                          context.showSnackBar('added_to_cart'.tr());
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
