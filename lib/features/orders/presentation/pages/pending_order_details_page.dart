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
  late PageController _pageController;
  OrderStatus? _actionStatus;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _actionStatus = widget.order.status;
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
                color: context.theme.primaryColor,
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
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: OrderInfoHeader(order: order),
                    ),
                    SizedBox(height: 16.h),

                    if (order.clientImage != null &&
                        order.clientImage!.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: _buildClientInfoSection(context, order),
                      ),
                      SizedBox(height: 16.h),
                    ],

                    if (order.productImagePaths.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: _buildProductsSection(context, order),
                      ),
                      SizedBox(height: 16.h),
                    ],

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

                    if (order.address != null && order.address!.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: DeliveryAddressSection(order: order),
                      ),
                      SizedBox(height: 24.h),
                    ],

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: OrderSummaryCard(order: order),
                    ),
                    SizedBox(height: 16.h),

                    _buildOrderActions(context, orderState, order),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
              if (orderState.detailsStatus == OrderDetailsStatus.loading)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    color: context.theme.primaryColor,
                    backgroundColor: context.theme.primaryColor.withAlpha(30),
                  ),
                ),
              if (orderState.detailsStatus == OrderDetailsStatus.failure)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: context.colorScheme.error,
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

  Widget _buildClientInfoSection(BuildContext context, OrderEntity order) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: AppImage(
            imageUrl: order.clientImage!,
            width: 46.w,
            height: 41.h,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            order.customerName ?? '',
            style: tt.titleMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductsSection(BuildContext context, OrderEntity order) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المنتجات',
          style: tt.titleMedium?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: order.productImagePaths.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, i) {
              final name = i < order.productNames.length
                  ? order.productNames[i]
                  : '';
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: AppImage(
                      imageUrl: order.productImagePaths[i],
                      width: 64.w,
                      height: 64.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    name,
                    style: tt.bodySmall?.copyWith(fontSize: 12.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOrderActions(
    BuildContext context,
    OrderDetailsState orderState,
    OrderEntity order,
  ) {
    if (!_currentRole.isDriver) return const SizedBox.shrink();

    final tt = context.textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          if (_actionStatus == OrderStatus.pendingApproval)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 163.w,
                  height: 60.h,
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
                SizedBox(width: 16.w),
                SizedBox(
                  width: 163.w,
                  height: 60.h,
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
                            child: CircularProgressIndicator(
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
              ],
            ),
          if (_actionStatus == OrderStatus.preparing)
            SizedBox(
              width: 343.w,
              height: 60.h,
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
