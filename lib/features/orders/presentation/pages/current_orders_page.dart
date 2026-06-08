import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_event.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_state.dart';
import 'package:thimar/features/orders/presentation/widgets/order_card.dart';

class CurrentOrdersPage extends StatefulWidget {
  const CurrentOrdersPage({super.key});

  @override
  State<CurrentOrdersPage> createState() => _CurrentOrdersPageState();
}

class _CurrentOrdersPageState extends State<CurrentOrdersPage>
    with AutomaticKeepAliveClientMixin {
  final _searchController = TextEditingController();
  bool _isSearchActive = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

    return Material(
      type: MaterialType.transparency,
      child: Column(
        children: [
          SearchField(
            controller: _searchController,
            onChanged: _onSearchChanged,
          ),
          Expanded(
            child: _isSearchActive ? _buildSearchResults() : _buildOrdersList(),
          ),
        ],
      ),
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
          prev.currentOrders != curr.currentOrders ||
          prev.errorMessage != curr.errorMessage,
      builder: (context, state) {
        if (state.status == OrdersStatus.loading) {
          return const AppLoading();
        }

        if (state.status == OrdersStatus.failure) {
          return AppError(
            message: state.errorMessage ?? 'unexpected_error'.tr(),
            onRetry: () {
              context.read<OrdersBloc>().add(const CurrentOrdersRequested());
            },
          );
        }

        if (state.currentOrders.isEmpty) {
          return AppEmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'لا يوجد طلبات جارية',
            subtitle: 'سيتم عرض الطلبات الجارية (قيد التوصيل) هنا',
          );
        }

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 20.h),
          itemCount: state.currentOrders.length,
          separatorBuilder: (context, index) => SizedBox(height: 14.h),
          itemBuilder: (context, index) {
            final order = state.currentOrders[index];
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
