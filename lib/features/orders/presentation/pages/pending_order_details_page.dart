import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/cache/cache_constants.dart';
import 'package:thimar/core/cache/cache_keys.dart';
import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/core/models/user_role.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/presentation/widgets/order_details_widgets.dart';
import 'package:thimar/features/orders/presentation/bloc/order_details_cubit.dart';
import 'package:thimar/features/orders/presentation/bloc/order_details_state.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_event.dart';
import 'package:thimar/features/orders/presentation/widgets/payment_confirmation_dialog.dart';

class PendingOrderDetailsPage extends StatefulWidget {
  final OrderEntity order;
  const PendingOrderDetailsPage({super.key, required this.order});

  @override
  State<PendingOrderDetailsPage> createState() =>
      _PendingOrderDetailsPageState();
}

class _PendingOrderDetailsPageState extends State<PendingOrderDetailsPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderDetailsCubit>().loadOrderDetails(widget.order.id);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.textTheme;

    return BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status ||
          prev.acceptSuccessMessage != curr.acceptSuccessMessage ||
          prev.rejectSuccessMessage != curr.rejectSuccessMessage ||
          prev.startDeliverySuccessMessage !=
              curr.startDeliverySuccessMessage ||
          prev.finishSuccessMessage != curr.finishSuccessMessage,
      listener: (context, state) {
        if (state.status == OrderStatus.delivered ||
            state.status == OrderStatus.cancelled) {
          context.pop();
          if (state.status == OrderStatus.delivered) {
            context.showSnackBar('تم توصيل الطلب بنجاح');
          }
          if (state.status == OrderStatus.cancelled) {
            context.showSnackBar('تم رفض الطلب');
          }
        }
        if (state.acceptSuccessMessage != null &&
            state.acceptSuccessMessage!.isNotEmpty) {
          context.showSnackBar(state.acceptSuccessMessage!);
          _refreshOrders(context, const [
            PendingOrdersRequested(),
            CurrentOrdersRequested(),
          ]);
        }
        if (state.rejectSuccessMessage != null &&
            state.rejectSuccessMessage!.isNotEmpty) {
          context.showSnackBar(state.rejectSuccessMessage!);
          _refreshOrders(context, const [PendingOrdersRequested()]);
        }
        if (state.startDeliverySuccessMessage != null &&
            state.startDeliverySuccessMessage!.isNotEmpty) {
          context.showSnackBar(state.startDeliverySuccessMessage!);
          _refreshOrders(context, const [CurrentOrdersRequested()]);
        }
        if (state.finishSuccessMessage != null &&
            state.finishSuccessMessage!.isNotEmpty) {
          context.showSnackBar(state.finishSuccessMessage!);
          _refreshOrders(context, const [
            CurrentOrdersRequested(),
            FinishedOrdersRequested(),
          ]);
        }
      },
      builder: (context, orderState) {
        final order = orderState.order ?? widget.order;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'order_details'.tr(),
              style: tt.headlineSmall?.copyWith(
                color: context.theme.primaryColor,
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            centerTitle: true,
            leading: const AppBackButton(),
          ),
          body: orderState.detailsStatus == OrderDetailsStatus.loading
              ? const Center(child: AppLoading())
              : orderState.detailsStatus == OrderDetailsStatus.failure
              ? AppError(
                  message: orderState.errorMessage ?? 'unexpected_error'.tr(),
                  onRetry: () {
                    context.read<OrderDetailsCubit>().loadOrderDetails(
                      widget.order.id,
                    );
                  },
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: OrderInfoHeader(order: order),
                      ),
                      SizedBox(height: 16.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: DeliveryTimeSection(order: order),
                      ),
                      SizedBox(height: 16.h),

                      if (order.notes != null && order.notes!.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: NotesDisplaySection(notes: order.notes!),
                        ),
                        SizedBox(height: 16.h),
                      ],

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: DeliveryAddressSection(order: order),
                      ),
                      SizedBox(height: 24.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: OrderSummaryCard(order: order),
                      ),
                      SizedBox(height: 24.h),

                      _buildDriverActions(context, orderState, order),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildDriverActions(
    BuildContext context,
    OrderDetailsState orderState,
    OrderEntity order,
  ) {
    if (!_currentRole.isDriver) return const SizedBox.shrink();

    final currentStatus = orderState.status ?? order.status;

    if (currentStatus == OrderStatus.pendingApproval) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'قبول',
                variant: ButtonVariant.primary,
                isLoading: orderState.isAccepting,
                onPressed: () {
                  context.read<OrderDetailsCubit>().acceptOrder(order.id);
                },
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: AppButton(
                label: 'رفض',
                variant: ButtonVariant.error,
                isLoading: orderState.isRejecting,
                onPressed: () {
                  context.read<OrderDetailsCubit>().rejectOrder(order.id);
                },
              ),
            ),
          ],
        ),
      );
    } else if (currentStatus == OrderStatus.preparing) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: AppButton(
          label: 'بدء التوصيل',
          variant: ButtonVariant.primary,
          isLoading: orderState.isStartingDelivery,
          onPressed: () {
            context.read<OrderDetailsCubit>().startDeliveringOrder(order.id);
          },
        ),
      );
    } else if (currentStatus == OrderStatus.onWay) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: AppButton(
          label: 'إنهاء الطلب',
          variant: ButtonVariant.primary,
          isLoading: orderState.isFinishing,
          onPressed: () {
            PaymentConfirmationDialog.show(
              context,
              totalAmount: order.total,
              onConfirm: (amount) {
                context.read<OrderDetailsCubit>().finishOrder(order.id, amount);
              },
            );
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }

  UserRole get _currentRole {
    return UserRole.fromString(
      sl<HiveCacheService>().get<String>(
        key: CacheKeys.userType,
        boxName: CacheConstants.userBox,
      ),
    );
  }

  void _refreshOrders(BuildContext context, List<OrdersEvent> events) {
    final ordersBloc = context.read<OrdersBloc?>();
    if (ordersBloc == null) return;

    for (final event in events) {
      ordersBloc.add(event);
    }
  }
}
