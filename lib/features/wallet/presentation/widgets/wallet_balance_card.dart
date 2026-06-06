import 'package:thimar/core/imports/core_imports.dart';

class WalletBalanceCard extends StatelessWidget {
  final double balance;

  const WalletBalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 36.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'your_balance'.tr(),
            style: tt.titleLarge?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 16.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${balance.toInt()} ',
                  style: tt.headlineLarge?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 32.sp,
                  ),
                ),
                TextSpan(
                  text: 'sar'.tr(),
                  style: tt.titleLarge?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
