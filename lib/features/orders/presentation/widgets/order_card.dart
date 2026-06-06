import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/presentation/widgets/order_status_badge.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onTap;

  const OrderCard({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return AppCard(
      onTap: onTap,
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
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${'order_label'.tr()} #${order.id}',
                          style: tt.titleLarge?.copyWith(
                            color: cs.primary,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          order.dateKey.tr(),
                          style: tt.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant.withValues(alpha: 0.68),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Flexible(
                    child: Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: OrderStatusBadge(status: order.status),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                child: Divider(
                  color: cs.outline.withValues(alpha: 0.06),
                  height: 1.h,
                  thickness: 1,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${order.total.toStringAsFixed(0)} ${'sar'.tr()}',
                    style: tt.titleLarge?.copyWith(
                      color: cs.primary,
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  OrderProductsPreview(order: order),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderProductsPreview extends StatelessWidget {
  final OrderEntity order;

  const OrderProductsPreview({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      if (order.extraProductsCount > 0)
        _MoreProductsChip(count: order.extraProductsCount),
      ...order.productImagePaths.take(3).map(_OrderProductThumb.new),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children
          .map(
            (child) => Padding(
              padding: EdgeInsetsDirectional.only(end: 6.w),
              child: child,
            ),
          )
          .toList(),
    );
  }
}

class _MoreProductsChip extends StatelessWidget {
  final int count;

  const _MoreProductsChip({required this.count});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Container(
      width: 38.w,
      height: 38.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Text(
        '+$count',
        style: tt.labelLarge?.copyWith(
          color: cs.primary,
          fontSize: 13.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _OrderProductThumb extends StatelessWidget {
  final String imagePath;

  const _OrderProductThumb(this.imagePath);

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Container(
      width: 38.w,
      height: 38.w,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(color: cs.primary.withValues(alpha: 0.72), width: 1),
      ),
      child: AppImage(
        imageUrl: imagePath,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(9.r),
      ),
    );
  }
}
