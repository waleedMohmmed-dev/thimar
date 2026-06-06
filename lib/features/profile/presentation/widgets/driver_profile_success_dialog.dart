import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/usecases/get_pending_orders_use_case.dart';

class DriverProfileSuccessDialog extends StatefulWidget {
  const DriverProfileSuccessDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const DriverProfileSuccessDialog(),
    );
  }

  @override
  State<DriverProfileSuccessDialog> createState() => _DriverProfileSuccessDialogState();
}

class _DriverProfileSuccessDialogState extends State<DriverProfileSuccessDialog> {
  bool _isLoading = false;

  Future<void> _handleProceed() async {
    setState(() => _isLoading = true);

    final useCase = sl<GetPendingOrdersUseCase>();
    final result = await useCase(const NoParams());

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _isLoading = false);
        context.pop();
        context.go(AppRoutes.home);
      },
      (orders) {
        setState(() => _isLoading = false);
        context.pop();

        // Find active order (preparing or onWay)
        final activeOrder = orders.where((order) => 
          order.status == OrderStatus.preparing || 
          order.status == OrderStatus.onWay
        ).firstOrNull;

        if (activeOrder != null) {
          context.goPendingOrderDetails(activeOrder);
        } else {
          context.go(AppRoutes.home);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: cs.primary,
                size: 48.r,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'تم قبول الطلب بنجاح',
              style: tt.titleLarge?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'يمكنك متابعة الطلب لتسليم المنتجات وإنهائها',
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            AppButton(
              label: 'متابعة الطلب',
              isLoading: _isLoading,
              variant: ButtonVariant.primary,
              onPressed: _handleProceed,
            ),
          ],
        ),
      ),
    );
  }
}
