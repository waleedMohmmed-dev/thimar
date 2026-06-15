import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/endpoints.dart';

class ChargeWalletPage extends StatefulWidget {
  const ChargeWalletPage({super.key});

  @override
  State<ChargeWalletPage> createState() => _ChargeWalletPageState();
}

class _ChargeWalletPageState extends State<ChargeWalletPage> {
  final _amountController = TextEditingController();
  final _transactionIdController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amountText = _amountController.text.trim();
    final transactionId = _transactionIdController.text.trim();

    if (amountText.isEmpty) {
      context.showErrorSnackBar('يرجى إدخال المبلغ');
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      context.showErrorSnackBar('يرجى إدخال مبلغ صحيح');
      return;
    }

    if (transactionId.isEmpty) {
      context.showErrorSnackBar('يرجى إدخال رقم العملية');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final apiService = sl<ApiService>();
      final response = await apiService.post(
        Endpoints.walletCharge,
        body: {
          'amount': amount,
          'transaction_id': transactionId,
        },
      );

      if (!mounted) return;

      final status = response['status']?.toString() ?? '';
      final message = response['message']?.toString() ?? '';

      if (status == 'success') {
        context.showSuccessSnackBar(message.isNotEmpty ? message : 'تم شحن المحفظة بنجاح');
        context.pop();
      } else {
        setState(() => _isSubmitting = false);
        context.showErrorSnackBar(message.isNotEmpty ? message : 'حدث خطأ');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      context.showErrorSnackBar('حدث خطأ أثناء الاتصال بالخادم');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'شحن المحفظة',
          style: tt.headlineSmall?.copyWith(
            color: cs.primary,
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        leading: const AppBackButton(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: cs.primary.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 48.r,
                    color: cs.primary,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'شحن المحفظة',
                    style: tt.titleLarge?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'أدخل المبلغ ورقم العملية لشحن محفظتك',
                    style: tt.bodyMedium?.copyWith(
                      color: cs.outline,
                      fontSize: 13.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            _buildAmountField(cs, tt),
            SizedBox(height: 16.h),
            _buildTransactionIdField(cs, tt),
            SizedBox(height: 32.h),
            _buildSubmitButton(cs, tt),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField(ColorScheme cs, TextTheme tt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'المبلغ',
            style: tt.bodyLarge?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            style: tt.bodyMedium?.copyWith(
              fontSize: 16.sp,
              color: cs.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'المبلغ الخاص بك',
              hintStyle: tt.bodyMedium?.copyWith(
                color: cs.outline.withAlpha(150),
                fontSize: 14.sp,
              ),
              filled: true,
              fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: cs.outline.withAlpha(30),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: cs.primary.withAlpha(80),
                  width: 1.5,
                ),
              ),
              prefixIcon: Icon(
                Icons.monetization_on_rounded,
                color: cs.primary,
                size: 22.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionIdField(ColorScheme cs, TextTheme tt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'رقم العملية',
            style: tt.bodyLarge?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _transactionIdController,
            textAlign: TextAlign.right,
            style: tt.bodyMedium?.copyWith(
              fontSize: 16.sp,
              color: cs.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'أدخل رقم العملية',
              hintStyle: tt.bodyMedium?.copyWith(
                color: cs.outline.withAlpha(150),
                fontSize: 14.sp,
              ),
              filled: true,
              fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: cs.outline.withAlpha(30),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: cs.primary.withAlpha(80),
                  width: 1.5,
                ),
              ),
              prefixIcon: Icon(
                Icons.receipt_long_rounded,
                color: cs.primary,
                size: 22.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(ColorScheme cs, TextTheme tt) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          disabledBackgroundColor: cs.primary.withAlpha(60),
          disabledForegroundColor: Colors.white.withAlpha(150),
          elevation: 0,
          shadowColor: cs.primary.withAlpha(80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: _isSubmitting
            ? SizedBox(
                width: 24.r,
                height: 24.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                'ادفع',
                style: tt.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
      ),
    );
  }
}
