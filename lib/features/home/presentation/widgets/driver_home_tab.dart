import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_event.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_state.dart';
import 'package:thimar/features/home/presentation/widgets/driver_order_card.dart';

class DriverHomeTab extends StatefulWidget {
  const DriverHomeTab({super.key});

  @override
  State<DriverHomeTab> createState() => _DriverHomeTabState();
}

class _DriverHomeTabState extends State<DriverHomeTab> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(const PendingOrdersRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, OrdersState>(
      listenWhen: (prev, curr) =>
          prev.refuseSuccessMessage != curr.refuseSuccessMessage ||
          prev.refuseError != curr.refuseError,
      listener: (context, state) {
        if (state.refuseSuccessMessage != null &&
            state.refuseSuccessMessage!.isNotEmpty) {
          context.showSnackBar(state.refuseSuccessMessage!);
        }
        if (state.refuseError != null) {
          context.showSnackBar(state.refuseError!);
        }
      },
      child: _buildOrdersList(),
    );
  }

  Widget _buildOrdersList() {
    return BlocBuilder<OrdersBloc, OrdersState>(
      buildWhen: (prev, curr) =>
          prev.status != curr.status ||
          prev.pendingOrders != curr.pendingOrders ||
          prev.errorMessage != curr.errorMessage,
      builder: (context, state) {
        if (state.status == OrdersStatus.loading) {
          return const Center(child: AppLoading());
        }

        if (state.status == OrdersStatus.failure) {
          return AppError(
            message: state.errorMessage ?? 'unexpected_error'.tr(),
            onRetry: () {
              context.read<OrdersBloc>().add(const PendingOrdersRequested());
            },
          );
        }

        if (state.pendingOrders.isEmpty) {
          return AppEmptyState(
            icon: Icons.local_shipping_outlined,
            title: 'لا يوجد طلبات متاحة',
            subtitle: 'سيتم عرض الطلبات المتاحة للتوصيل هنا',
          );
        }

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 100.h),
          itemCount: state.pendingOrders.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final order = state.pendingOrders[index];
            return DriverOrderCard(order: order);
          },
        );
      },
    );
  }
}
