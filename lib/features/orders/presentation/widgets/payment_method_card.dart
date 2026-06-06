import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/presentation/widgets/payment_method.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod method;
  final String image;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.image,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? cs.primary : cs.outline.withAlpha(77),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
          color: isSelected ? cs.primary.withAlpha(20) : Colors.transparent,
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                image,
                width: 48.w,
                height: 32.h,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.credit_card,
                  color: isSelected ? cs.primary : cs.outline,
                  size: 32.sp,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: tt.bodySmall?.copyWith(
                color: isSelected ? cs.primary : cs.outline,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
