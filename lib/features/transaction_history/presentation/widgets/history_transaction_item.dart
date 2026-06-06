import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/transaction_history/domain/entities/transaction_entity.dart';
import 'package:thimar/features/transaction_history/presentation/widgets/product_thumbnails_row.dart';

class HistoryTransactionItem extends StatelessWidget {
  final TransactionEntity transaction;

  const HistoryTransactionItem({super.key, required this.transaction});

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}${_getArabicMonthName(dateTime.month)},${dateTime.year}';
  }

  String _getArabicMonthName(int month) {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    final isIncome = transaction.isIncome;
    final icon = isIncome ? Icons.add : Icons.remove;
    final iconColor = isIncome ? cs.primary : cs.error;
    final dateStr = _formatDate(transaction.dateTime);
    final typeLabel = transaction.type.label.tr();
    final amountStr = '${transaction.amount.toStringAsFixed(0)} ر.س';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateStr,
              style: tt.bodySmall?.copyWith(color: cs.outline, fontSize: 12.sp),
            ),
            Row(
              children: [
                Text(
                  typeLabel,
                  style: tt.bodyLarge?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconColor.withAlpha(30),
                  ),
                  child: Icon(icon, size: 14.sp, color: iconColor),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              amountStr,
              style: tt.headlineSmall?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w900,
                fontSize: 20.sp,
              ),
            ),
            if (transaction.orderId != null &&
                transaction.productImagePaths != null) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'طلب #${transaction.orderId}',
                    style: tt.bodyMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ProductThumbnailsRow(
                    productImages: transaction.productImagePaths ?? [],
                    extraProductsCount: transaction.extraProductsCount ?? 0,
                  ),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}
