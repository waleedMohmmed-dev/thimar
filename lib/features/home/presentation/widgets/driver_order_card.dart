import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_event.dart';
import 'package:thimar/features/orders/presentation/bloc/orders_state.dart';
import 'package:thimar/features/orders/presentation/widgets/order_card.dart';
import 'package:thimar/features/orders/presentation/widgets/order_status_badge.dart';

class DriverOrderCard extends StatelessWidget {
  final OrderEntity order;

  const DriverOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return AppCard(
      onTap: () => context.goPendingOrderDetails(order),
      elevation: 0,
      padding: EdgeInsets.zero,
      backgroundColor: cs.surface,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: cs.outline.withValues(alpha: 0.06),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.06),
              blurRadius: 22.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section: Order Code & Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${'order_label'.tr()} #${order.id}',
                    style: tt.titleLarge?.copyWith(
                      color: context.theme.primaryColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  OrderStatusBadge(status: order.status),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Divider(
                  color: cs.outline.withValues(alpha: 0.06),
                  height: 1.h,
                  thickness: 1,
                ),
              ),

              // Middle Section: Customer Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: cs.primaryContainer,
                    child: Icon(
                      Icons.person,
                      color: context.theme.primaryColor,
                      size: 24.r,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.customerName ?? 'عميل',
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.theme.primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16.r,
                              color: cs.onSurfaceVariant,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                order.address ?? 'عنوان غير متوفر',
                                style: tt.bodySmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Products Section
              OrderProductsPreview(order: order),
              
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Divider(
                  color: cs.outline.withValues(alpha: 0.06),
                  height: 1.h,
                  thickness: 1,
                ),
              ),

              // Bottom Section: Total Price & Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إجمالي الطلب',
                        style: tt.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${order.total.toStringAsFixed(0)} ${'sar'.tr()}',
                        style: tt.titleLarge?.copyWith(
                          color: context.theme.primaryColor,
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<OrdersBloc, OrdersState>(
                    buildWhen: (prev, curr) =>
                        prev.isRefusingOrder != curr.isRefusingOrder,
                    builder: (context, state) {
                      return Row(
                        children: [
                          SizedBox(
                            width: 100.w,
                            child: AppButton(
                              label: 'رفض',
                              size: ButtonSize.small,
                              variant: ButtonVariant.error,
                              isLoading: state.isRefusingOrder,
                              onPressed: () {
                                context
                                    .read<OrdersBloc>()
                                    .add(OrderRefused(order.id));
                              },
                            ),
                          ),
                          SizedBox(width: 8.w),
                          SizedBox(
                            width: 120.w,
                            child: AppButton(
                              label: 'عرض التفاصيل',
                              size: ButtonSize.small,
                              variant: ButtonVariant.primary,
                              onPressed: () =>
                                  context.goPendingOrderDetails(order),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
