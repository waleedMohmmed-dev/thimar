import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/transaction_history/domain/entities/transaction_entity.dart';

class TransactionItemWidget extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionItemWidget({Key? key, required this.transaction})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          transaction.type.icon,
                          style: TextStyle(fontSize: 18.sp),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            transaction.type.label.tr(),
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _formatDate(transaction.dateTime),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${transaction.isIncome ? '+' : '-'}${transaction.amount.toStringAsFixed(0)} ${_getCurrency()}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: transaction.isIncome ? Colors.green : Colors.black,
                    ),
                  ),
                  if (transaction.orderId != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      '#${transaction.orderId}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ],
          ),
          // Product images if available
          if (transaction.productImagePaths != null &&
              transaction.productImagePaths!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                ...List.generate(
                  transaction.productImagePaths!.length > 3
                      ? 3
                      : transaction.productImagePaths!.length,
                  (index) => Container(
                    width: 40.w,
                    height: 40.h,
                    margin: EdgeInsetsDirectional.only(end: 4.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.r),
                      child: Image.asset(
                        transaction.productImagePaths![index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(Icons.image_not_supported, size: 20.sp),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if (transaction.extraProductsCount != null &&
                    transaction.extraProductsCount! > 0) ...[
                  SizedBox(width: 4.w),
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Center(
                      child: Text(
                        '+${transaction.extraProductsCount}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final txDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (txDate == today) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (txDate == today.subtract(const Duration(days: 1))) {
      return 'yesterday'.tr();
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  String _getCurrency() {
    return 'ريس';
  }
}
