import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

class OrderSuccessDialog extends StatelessWidget {
  final VoidCallback? onViewDetails;
  const OrderSuccessDialog({super.key, this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.8, end: 1.0),
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastEaseInToSlowEaseOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/order_done.png',
                width: 120.w,
                height: 120.h,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 24.h),
              Text(
                'order_success_title'.tr(),
                style: tt.headlineSmall?.copyWith(
                  color: cs.primary,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                'order_success_subtitle'.tr(),
                style: tt.bodyMedium?.copyWith(
                  color: const Color(0xFF9E9E9E),
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () {
                  context.pop();
                  onViewDetails?.call();
                },
                child: Text(
                  'product_details'.tr(),
                  style: TextStyle(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              AppButton(
                label: 'nav_orders'.tr(),
                onPressed: () {
                  context.pop();
                  context.goOrders();
                },
                size: ButtonSize.large,
                variant: ButtonVariant.primary,
              ),
              SizedBox(height: 12.h),
              AppButton(
                label: 'nav_home'.tr(),
                onPressed: () {
                  context.pop();
                  context.goHome();
                },
                size: ButtonSize.large,
                variant: ButtonVariant.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
