import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/cache/cache_constants.dart';
import 'package:thimar/core/cache/cache_keys.dart';
import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/core/models/user_role.dart';
import 'package:thimar/features/orders/presentation/bloc/client_orders_bloc.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_event.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_state.dart';
import 'package:thimar/features/orders/presentation/pages/current_orders_page.dart';
import 'package:thimar/features/orders/presentation/pages/finished_orders_page.dart';
import 'package:thimar/features/orders/presentation/widgets/order_card.dart';

class OrdersPage extends StatelessWidget {
  final UserRole? role;

  const OrdersPage({super.key, this.role});

  @override
  Widget build(BuildContext context) {
    final currentRole = role ?? _cachedRole;

    if (!currentRole.isDriver) {
      return BlocProvider(
        create: (_) => sl<ClientOrdersBloc>()..add(const ClientOrdersStarted()),
        child: _ClientOrdersView(showScaffold: role == null),
      );
    }

    final hasOrdersBloc = context.read<OrdersBloc?>() != null;

    if (hasOrdersBloc) {
      return const _OrdersView();
    }

    return BlocProvider(
      create: (_) => sl<OrdersBloc>(),
      child: const _OrdersView(),
    );
  }

  UserRole get _cachedRole {
    return UserRole.fromString(
      sl<HiveCacheService>().get<String>(
        key: CacheKeys.userType,
        boxName: CacheConstants.userBox,
      ),
    );
  }
}

class _OrdersView extends StatefulWidget {
  const _OrdersView();

  @override
  State<_OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<_OrdersView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: OrdersTab.current.pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return BlocListener<OrdersBloc, OrdersState>(
      listenWhen: (prev, curr) =>
          prev.selectedTab != curr.selectedTab ||
          prev.deliveringStartedMessage != curr.deliveringStartedMessage,
      listener: (context, state) {
        if (state.deliveringStartedMessage != null &&
            state.deliveringStartedMessage!.isNotEmpty) {
          context.showSnackBar(state.deliveringStartedMessage!);
          context.read<OrdersBloc>().add(
                const ClearDeliveringStartedMessage(),
              );
        }
        _pageController.animateToPage(
          state.selectedTab.pageIndex,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
        );
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 28.h, 16.w, 0),
            child: Text(
              'orders_title'.tr(),
              style: tt.headlineSmall?.copyWith(
                color: cs.primary,
                fontSize: 27.sp,
                fontWeight: FontWeight.w900,
                height: 1.15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 28.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: BlocSelector<OrdersBloc, OrdersState, OrdersTab>(
              selector: (state) => state.selectedTab,
              builder: (context, selectedTab) {
                return AppSegmentedControl<OrdersTab>(
                  value: selectedTab,
                  items: OrdersTab.values
                      .map(
                        (tab) => AppSegmentedControlItem<OrdersTab>(
                          value: tab,
                          labelKey: tab.labelKey,
                        ),
                      )
                      .toList(),
                  onChanged: (tab) {
                    context.read<OrdersBloc>().add(OrdersTabChanged(tab));
                  },
                );
              },
            ),
          ),
          SizedBox(height: 18.h),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [CurrentOrdersPage(), FinishedOrdersPage()],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClientOrdersView extends StatelessWidget {
  final bool showScaffold;

  const _ClientOrdersView({required this.showScaffold});

  @override
  Widget build(BuildContext context) {
    final tt = context.textTheme;

    final content = Column(
      children: [
        if (!showScaffold) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 28.h, 16.w, 0),
            child: Text(
              'orders_title'.tr(),
              style: tt.headlineSmall?.copyWith(
                color: context.colorScheme.primary,
                fontSize: 27.sp,
                fontWeight: FontWeight.w900,
                height: 1.15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 18.h),
        ],
        Expanded(
          child: BlocBuilder<ClientOrdersBloc, ClientOrdersState>(
            builder: (context, state) {
              if (state.status == ClientOrdersStatus.loading ||
                  state.status == ClientOrdersStatus.initial) {
                return const Center(child: AppLoading());
              }

              if (state.status == ClientOrdersStatus.failure) {
                return AppError(
                  message: state.errorMessage ?? 'unexpected_error'.tr(),
                  onRetry: () {
                    context.read<ClientOrdersBloc>().add(
                      const ClientOrdersStarted(),
                    );
                  },
                );
              }

              if (state.orders.isEmpty) {
                return AppEmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'no_orders'.tr(),
                  subtitle: 'orders_empty_subtitle'.tr(),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
                itemCount: state.orders.length,
                separatorBuilder: (context, index) => SizedBox(height: 14.h),
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return OrderCard(order: order);
                },
              );
            },
          ),
        ),
      ],
    );

    if (!showScaffold) return content;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'orders_title'.tr(),
          style: tt.headlineSmall?.copyWith(
            color: context.colorScheme.primary,
            fontSize: 27.sp,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        centerTitle: true,
      ),
      body: content,
    );
  }
}
