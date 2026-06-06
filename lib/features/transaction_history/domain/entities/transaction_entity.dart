import 'package:thimar/core/imports/packages_imports.dart';

enum TransactionType {
  walletTopUp, // شحن المحفظة
  orderPayment, // دفعت مقابل هذا الطلب
  walletWithdraw, // سحب من المحفظة
  refund, // استرجاع
  bonus, // مكافأة
}

extension TransactionTypeX on TransactionType {
  String get label {
    return switch (this) {
      TransactionType.walletTopUp => 'wallet_top_up',
      TransactionType.orderPayment => 'order_payment',
      TransactionType.walletWithdraw => 'wallet_withdraw',
      TransactionType.refund => 'refund',
      TransactionType.bonus => 'bonus',
    };
  }

  String get icon {
    return switch (this) {
      TransactionType.walletTopUp => '➕',
      TransactionType.orderPayment => '💳',
      TransactionType.walletWithdraw => '📤',
      TransactionType.refund => '↩️',
      TransactionType.bonus => '🎁',
    };
  }
}

class TransactionEntity extends Equatable {
  final String id;
  final TransactionType type;
  final double amount;
  final DateTime dateTime;
  final String? description;
  final String? orderId;
  final List<String>? productImagePaths;
  final int? extraProductsCount;
  final bool isIncome; // true for income, false for expense

  const TransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    required this.dateTime,
    this.description,
    this.orderId,
    this.productImagePaths,
    this.extraProductsCount,
    required this.isIncome,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    amount,
    dateTime,
    description,
    orderId,
    productImagePaths,
    extraProductsCount,
    isIncome,
  ];
}
