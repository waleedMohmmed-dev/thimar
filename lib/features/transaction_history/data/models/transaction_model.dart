import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/transaction_history/domain/entities/transaction_entity.dart';

class TransactionModel extends Equatable {
  final int id;
  final double amount;
  final double beforeCharge;
  final double afterCharge;
  final String date;
  final String statusTrans;
  final String status;
  final String transactionType;
  final String state;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.beforeCharge,
    required this.afterCharge,
    required this.date,
    required this.statusTrans,
    required this.status,
    required this.transactionType,
    required this.state,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int? ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      beforeCharge: (json['before_charge'] as num?)?.toDouble() ?? 0.0,
      afterCharge: (json['after_charge'] as num?)?.toDouble() ?? 0.0,
      date: json['date']?.toString() ?? '',
      statusTrans: json['status_trans']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      transactionType: json['transaction_type']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
    );
  }

  TransactionEntity toEntity() {
    final isIncome = transactionType == 'charge' ||
        transactionType == 'refund' ||
        transactionType == 'bonus';

    return TransactionEntity(
      id: id.toString(),
      type: _mapType(transactionType),
      amount: amount,
      dateTime: DateTime.tryParse(date) ?? DateTime.now(),
      description: statusTrans,
      isIncome: isIncome,
      beforeCharge: beforeCharge,
      afterCharge: afterCharge,
    );
  }

  TransactionType _mapType(String type) {
    return switch (type) {
      'charge' => TransactionType.walletTopUp,
      'cashout' => TransactionType.walletWithdraw,
      'refund' => TransactionType.refund,
      'bonus' => TransactionType.bonus,
      _ => TransactionType.orderPayment,
    };
  }

  @override
  List<Object?> get props => [
        id,
        amount,
        beforeCharge,
        afterCharge,
        date,
        statusTrans,
        status,
        transactionType,
        state,
      ];
}
