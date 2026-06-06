import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final tt = context.textTheme;
    final colors = _OrderStatusColors.from(context, status);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        _labelKey(status).tr(),
        style: tt.labelMedium?.copyWith(
          color: colors.foreground,
          fontSize: 12.sp,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String _labelKey(OrderStatus status) {
    return switch (status) {
      OrderStatus.pendingApproval => 'order_status_pending_approval',
      OrderStatus.preparing => 'order_status_preparing',
      OrderStatus.onWay => 'order_status_on_way',
      OrderStatus.delivered => 'order_status_delivered',
      OrderStatus.cancelled => 'order_status_cancelled',
    };
  }
}

class _OrderStatusColors {
  final Color background;
  final Color foreground;

  const _OrderStatusColors({
    required this.background,
    required this.foreground,
  });

  factory _OrderStatusColors.from(BuildContext context, OrderStatus status) {
    final cs = context.colorScheme;

    return switch (status) {
      OrderStatus.pendingApproval => _OrderStatusColors(
        background: cs.primaryContainer.withValues(alpha: 0.34),
        foreground: cs.primary,
      ),
      OrderStatus.preparing => _OrderStatusColors(
        background: cs.secondaryContainer.withValues(alpha: 0.42),
        foreground: cs.primary,
      ),
      OrderStatus.onWay => _OrderStatusColors(
        background: cs.tertiaryContainer.withValues(alpha: 0.55),
        foreground: cs.tertiary,
      ),
      OrderStatus.delivered => _OrderStatusColors(
        background: cs.primaryContainer.withValues(alpha: 0.52),
        foreground: cs.primary,
      ),
      OrderStatus.cancelled => _OrderStatusColors(
        background: cs.errorContainer.withValues(alpha: 0.7),
        foreground: cs.error,
      ),
    };
  }
}
