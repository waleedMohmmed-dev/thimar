import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_event.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_state.dart';
import 'package:thimar/features/orders/presentation/pages/current_orders_page.dart';
import 'package:thimar/features/orders/presentation/pages/finished_orders_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hasOrdersBloc = context.read<OrdersBloc?>() != null;

    if (hasOrdersBloc) {
      return const _OrdersView();
    }

    return BlocProvider(
      create: (_) => sl<OrdersBloc>(),
      child: const _OrdersView(),
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
    // Removed eager fetch
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
      listenWhen: (prev, curr) => prev.selectedTab != curr.selectedTab,
      listener: (context, state) {
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
