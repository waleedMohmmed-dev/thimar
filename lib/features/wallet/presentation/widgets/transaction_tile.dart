import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/wallet/domain/entities/transaction_entity.dart';

class TransactionTile extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    final isPositive = transaction.type == TransactionType.deposit ||
        transaction.type == TransactionType.refund;

    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                _TypeIcon(isPositive: isPositive),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.description,
                        style: tt.bodyLarge?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _formatDate(transaction.date),
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${transaction.amount.toInt()} ${'sar'.tr()}',
                  style: tt.titleLarge?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (transaction.type == TransactionType.payment) ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  SizedBox(width: 44.w), // Icon width + spacing
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${'order'.tr()} #4587',
                          style: tt.bodyMedium?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            const _ProductImage(path: 'assets/images/fruit.png'),
                            SizedBox(width: 8.w),
                            const _ProductImage(path: 'assets/images/vegetable.png'),
                            SizedBox(width: 8.w),
                            const _ProductImage(path: 'assets/images/steak.png'),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: BoxDecoration(
                                color: cs.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                '+2',
                                style: tt.labelSmall?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Simplified format to match design "27 يونيو, 2021"
    return '${date.day} ${_getMonthName(date.month)}, ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

class _TypeIcon extends StatelessWidget {
  final bool isPositive;

  const _TypeIcon({required this.isPositive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: isPositive
            ? const Color(0xFFE2F3E2)
            : const Color(0xFFFBE8E8),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Icon(
          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
          color: isPositive ? Colors.green : Colors.red,
          size: 18.r,
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String path;

  const _ProductImage({required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: Image.asset(path, fit: BoxFit.cover),
      ),
    );
  }
}
