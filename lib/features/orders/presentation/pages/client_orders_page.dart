import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/orders/presentation/bloc/client_orders_bloc.dart';
import 'package:thimar/features/orders/presentation/widgets/order_card.dart';

class ClientOrdersPage extends StatelessWidget {
  const ClientOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ClientOrdersBloc>()..add(const ClientOrdersStarted()),
      child: const _ClientOrdersView(),
    );
  }
}

class _ClientOrdersView extends StatelessWidget {
  const _ClientOrdersView();

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'orders_title'.tr(),
          style: tt.headlineSmall?.copyWith(
            color: cs.primary,
            fontSize: 27.sp,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ClientOrdersBloc, ClientOrdersState>(
        builder: (context, state) {
          if (state.status == ClientOrdersStatus.loading ||
              state.status == ClientOrdersStatus.initial) {
            return const Center(child: AppLoading());
          }

          if (state.status == ClientOrdersStatus.failure) {
            return AppError(
              message: state.errorMessage ?? 'unexpected_error'.tr(),
              onRetry: () {
                context.read<ClientOrdersBloc>().add(const ClientOrdersStarted());
              },
            );
          }

          if (state.orders.isEmpty) {
            return AppEmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'لا توجد طلبات',
              subtitle: 'لم تقم بأي طلبات بعد',
            );
          }

          return ListView.separated(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
            itemCount: state.orders.length,
            separatorBuilder: (context, index) => SizedBox(height: 14.h),
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return OrderCard(
                order: order,
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
