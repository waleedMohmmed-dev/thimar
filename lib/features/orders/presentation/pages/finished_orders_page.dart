import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_event.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_state.dart';
import 'package:thimar/features/orders/presentation/widgets/order_card.dart';

class FinishedOrdersPage extends StatefulWidget {
  const FinishedOrdersPage({super.key});

  @override
  State<FinishedOrdersPage> createState() => _FinishedOrdersPageState();
}

class _FinishedOrdersPageState extends State<FinishedOrdersPage>
    with AutomaticKeepAliveClientMixin {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSearchActive = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<OrdersBloc>().add(const FinishedOrdersRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<OrdersBloc>().add(const FinishedOrdersLoadMore());
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearchActive = query.trim().isNotEmpty;
    });
    context.read<OrdersBloc>().add(OrdersSearched(query));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        SearchField(
          controller: _searchController,
          onChanged: _onSearchChanged,
        ),
        Expanded(
          child: _isSearchActive ? _buildSearchResults() : _buildOrdersList(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<OrdersBloc, OrdersState>(
      buildWhen: (prev, curr) =>
          prev.searchResults != curr.searchResults ||
          prev.isSearching != curr.isSearching ||
          prev.searchError != curr.searchError,
      builder: (context, state) {
        if (state.isSearching) {
          return const Center(child: AppLoading());
        }

        if (state.searchError != null) {
          return AppError(
            message: state.searchError!,
            onRetry: () {
              context.read<OrdersBloc>().add(
                    OrdersSearched(_searchController.text),
                  );
            },
          );
        }

        if (state.searchResults.isEmpty) {
          return const EmptySearchState();
        }

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 20.h),
          itemCount: state.searchResults.length,
          separatorBuilder: (context, index) => SizedBox(height: 14.h),
          itemBuilder: (context, index) {
            final order = state.searchResults[index];
            return OrderCard(
              order: order,
              onTap: () => context.goPendingOrderDetails(order),
            );
          },
        );
      },
    );
  }

  Widget _buildOrdersList() {
    return BlocBuilder<OrdersBloc, OrdersState>(
      buildWhen: (prev, curr) =>
          prev.status != curr.status ||
          prev.finishedOrders != curr.finishedOrders ||
          prev.errorMessage != curr.errorMessage ||
          prev.finishedHasMore != curr.finishedHasMore ||
          prev.isFinishedLoadingMore != curr.isFinishedLoadingMore,
      builder: (context, state) {
        if (state.status == OrdersStatus.loading ||
            state.status == OrdersStatus.initial) {
          return const AppLoading();
        }

        if (state.status == OrdersStatus.failure) {
          return AppError(
            message: state.errorMessage ?? 'unexpected_error'.tr(),
            onRetry: () {
              context.read<OrdersBloc>().add(const FinishedOrdersRequested());
            },
          );
        }

        if (state.finishedOrders.isEmpty) {
          return AppEmptyState(
            icon: Icons.task_alt_outlined,
            title: 'no_finished_orders'.tr(),
            subtitle: 'orders_empty_subtitle'.tr(),
          );
        }

        return ListView.separated(
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 20.h),
          itemCount: state.finishedOrders.length +
              (state.finishedHasMore ? 1 : 0),
          separatorBuilder: (context, index) => SizedBox(height: 14.h),
          itemBuilder: (context, index) {
            if (index == state.finishedOrders.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: AppLoading(),
                ),
              );
            }
            final order = state.finishedOrders[index];
            return OrderCard(
              order: order,
              onTap: () => context.goPendingOrderDetails(order),
            );
          },
        );
      },
    );
  }
}
