import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/presentation/widgets/payment_method.dart';
import 'package:thimar/features/orders/presentation/widgets/payment_method_card.dart';

class PaymentMethodSection extends StatelessWidget {
  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod> onMethodChanged;

  const PaymentMethodSection({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'choose_payment_method'.tr(),
          style: tt.bodyLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PaymentMethodCard(
              method: PaymentMethod.mastercard,
              image: 'assets/images/masstercard.png',
              label: 'Mastercard',
              isSelected: selectedMethod == PaymentMethod.mastercard,
              onTap: () => onMethodChanged(PaymentMethod.mastercard),
            ),
            PaymentMethodCard(
              method: PaymentMethod.visa,
              image: 'assets/images/visa.png',
              label: 'Visa',
              isSelected: selectedMethod == PaymentMethod.visa,
              onTap: () => onMethodChanged(PaymentMethod.visa),
            ),
            PaymentMethodCard(
              method: PaymentMethod.cash,
              image: 'assets/images/cash.jpg',
              label: 'cash'.tr(),
              isSelected: selectedMethod == PaymentMethod.cash,
              onTap: () => onMethodChanged(PaymentMethod.cash),
            ),
          ],
        ),
      ],
    );
  }
}
