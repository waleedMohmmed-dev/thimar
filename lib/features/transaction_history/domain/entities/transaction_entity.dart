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
      TransactionType.walletTopUp => 'شحن المحفظة',
      TransactionType.orderPayment => 'دفعت مقابل هذا الطلب',
      TransactionType.walletWithdraw => 'سحب من المحفظة',
      TransactionType.refund => 'استرجاع',
      TransactionType.bonus => 'مكافأة',
    };
  }
}

class TransactionEntity extends Equatable {
  final String id;
  final TransactionType type;
  final double amount;
  final DateTime dateTime;
  final String? description;
  final double beforeCharge;
  final double afterCharge;
  final bool isIncome;

  const TransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    required this.dateTime,
    this.description,
    this.beforeCharge = 0,
    this.afterCharge = 0,
    required this.isIncome,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        amount,
        dateTime,
        description,
        beforeCharge,
        afterCharge,
        isIncome,
      ];
}
