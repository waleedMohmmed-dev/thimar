import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/shared/widgets/app_button.dart';
import 'package:thimar/core/shared/widgets/app_text_field.dart';

class PaymentConfirmationDialog extends StatefulWidget {
  final double totalAmount;
  final ValueChanged<double> onConfirm;

  const PaymentConfirmationDialog({
    super.key,
    required this.totalAmount,
    required this.onConfirm,
  });

  static void show(BuildContext context, {required double totalAmount, required ValueChanged<double> onConfirm}) {
    showDialog(
      context: context,
      builder: (context) => PaymentConfirmationDialog(
        totalAmount: totalAmount,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<PaymentConfirmationDialog> createState() => _PaymentConfirmationDialogState();
}

class _PaymentConfirmationDialogState extends State<PaymentConfirmationDialog> {
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'المبلغ المستحق من العميل',
                style: tt.titleLarge?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                '${widget.totalAmount} ر.س',
                style: tt.headlineMedium?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 24.h),
              AppTextField(
                controller: _amountController,
                hintText: 'المبلغ المحصل',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال المبلغ';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null) {
                    return 'الرجاء إدخال مبلغ صحيح';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'إلغاء',
                      variant: ButtonVariant.outline,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: AppButton(
                      label: 'تأكيد',
                      variant: ButtonVariant.primary,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final amount = double.parse(_amountController.text.trim());
                          Navigator.pop(context);
                          widget.onConfirm(amount);
                        }
                      },
                    ),
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
