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

class PendingOrderDetailsPage extends StatefulWidget {
  final OrderEntity order;
  const PendingOrderDetailsPage({super.key, required this.order});

  @override
  State<PendingOrderDetailsPage> createState() =>
      _PendingOrderDetailsPageState();
}

class _PendingOrderDetailsPageState extends State<PendingOrderDetailsPage> {
  OrderStatus? _actionStatus;

  @override
  void initState() {
    super.initState();
    _actionStatus = widget.order.status;
    if (_currentRole.isDriver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<OrderDetailsCubit>().loadOrderDetails(widget.order.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status ||
          prev.acceptSuccessMessage != curr.acceptSuccessMessage ||
          prev.rejectSuccessMessage != curr.rejectSuccessMessage ||
          prev.finishSuccessMessage != curr.finishSuccessMessage ||
          prev.acceptError != curr.acceptError ||
          prev.rejectError != curr.rejectError,
      listener: (context, state) {
        if (state.acceptError != null && state.acceptError!.isNotEmpty) {
          setState(() {
            _actionStatus = OrderStatus.pendingApproval;
          });
        }
        if (state.rejectError != null && state.rejectError!.isNotEmpty) {
          setState(() {
            _actionStatus = null;
          });
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
          context.pop();
        }

        if (state.finishSuccessMessage != null &&
            state.finishSuccessMessage!.isNotEmpty) {
          context.showSnackBar(state.finishSuccessMessage!);
          _refreshOrders(context, const [
            CurrentOrdersRequested(),
            FinishedOrdersRequested(),
          ]);
          context.pop();
        }
      },
      builder: (context, orderState) {
        final order = orderState.order ?? widget.order;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'order_details'.tr(),
              style: tt.headlineSmall?.copyWith(
                color: cs.primary,
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            centerTitle: true,
            leading: const AppBackButton(),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      OrderInfoHeader(order: order),
                      SizedBox(height: 24.h),

                      DeliveryAddressSection(order: order),
                      SizedBox(height: 24.h),

                      OrderSummaryCard(order: order),
                      SizedBox(height: 32.h),

                      _buildOrderActions(context, orderState, order),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              if (orderState.detailsStatus == OrderDetailsStatus.loading)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    color: cs.primary,
                    backgroundColor: cs.primary.withAlpha(30),
                  ),
                ),
              if (_currentRole.isDriver &&
                  orderState.detailsStatus == OrderDetailsStatus.failure)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: cs.error,
                    padding: EdgeInsets.all(12.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            orderState.errorMessage ?? 'unexpected_error'.tr(),
                            style: tt.bodySmall?.copyWith(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<OrderDetailsCubit>().loadOrderDetails(
                              widget.order.id,
                            );
                          },
                          child: Text(
                            'إعادة المحاولة',
                            style: tt.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderActions(
    BuildContext context,
    OrderDetailsState orderState,
    OrderEntity order,
  ) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    if (_currentRole.isDriver) {
      return _buildDriverActions(context, orderState, order);
    }

    return _buildClientActions(context, order, tt, cs);
  }

  Widget _buildClientActions(
    BuildContext context,
    OrderEntity order,
    TextTheme tt,
    ColorScheme cs,
  ) {
    if (order.status == OrderStatus.cancelled) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (order.status != OrderStatus.delivered)
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFDE8E8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 0,
              ),
              onPressed: () {
                _showCancelDialog(context, order);
              },
              child: Text(
                'إلغاء الطلب',
                style: tt.bodyLarge?.copyWith(
                  color: const Color(0xFFDC3545),
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        if (order.status != OrderStatus.delivered) SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 0,
            ),
            onPressed: () {
              context.push(AppRoutes.rateOrder, extra: order);
            },
            child: Text(
              'تقييم المنتج',
              style: tt.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverActions(
    BuildContext context,
    OrderDetailsState orderState,
    OrderEntity order,
  ) {
    final tt = context.textTheme;

    return Column(
      children: [
        if (_actionStatus == OrderStatus.pendingApproval)
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _actionStatus = OrderStatus.preparing;
                      });
                    },
                    child: Text(
                      'قبول',
                      style: tt.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: SizedBox(
                  height: 56.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: orderState.isRejecting
                        ? null
                        : () {
                            context.read<OrderDetailsCubit>().rejectOrder(
                              order.id,
                            );
                          },
                    child: orderState.isRejecting
                        ? SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'رفض',
                            style: tt.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        if (_actionStatus == OrderStatus.preparing)
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: () {
                context.read<OrdersBloc?>()?.add(
                  OrderDeliveringStarted(
                    order.copyWith(status: OrderStatus.onWay),
                  ),
                );
                context.pop();
              },
              child: Text(
                'بدء التوصيل',
                style: tt.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context, OrderEntity order) {
    final tt = context.textTheme;
    final cs = context.colorScheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'إلغاء الطلب',
          style: tt.titleLarge?.copyWith(
            color: cs.error,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'هل أنت متأكد من إلغاء هذا الطلب؟',
          style: tt.bodyMedium?.copyWith(
            color: cs.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'لا',
              style: tt.bodyMedium?.copyWith(color: cs.outline),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.pop();
            },
            child: Text(
              'نعم، إلغاء',
              style: tt.bodyMedium?.copyWith(
                color: cs.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
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
