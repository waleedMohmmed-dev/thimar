import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/wallet/domain/entities/wallet_transaction_entity.dart';

class WalletTransactionModel extends Equatable {
  final int id;
  final double amount;
  final double beforeCharge;
  final double afterCharge;
  final String date;
  final String statusTrans;
  final String transactionType;
  final String state;

  const WalletTransactionModel({
    required this.id,
    required this.amount,
    required this.beforeCharge,
    required this.afterCharge,
    required this.date,
    required this.statusTrans,
    required this.transactionType,
    required this.state,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] as int? ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      beforeCharge: (json['before_charge'] as num?)?.toDouble() ?? 0,
      afterCharge: (json['after_charge'] as num?)?.toDouble() ?? 0,
      date: json['date']?.toString() ?? '',
      statusTrans: json['status_trans']?.toString() ?? '',
      transactionType: json['transaction_type']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
    );
  }

  WalletTransactionEntity toEntity() {
    return WalletTransactionEntity(
      id: id,
      amount: amount,
      beforeCharge: beforeCharge,
      afterCharge: afterCharge,
      date: date,
      statusTrans: statusTrans,
      transactionType: transactionType,
      state: state,
    );
  }

  @override
  List<Object?> get props => [
    id,
    amount,
    beforeCharge,
    afterCharge,
    date,
    statusTrans,
    transactionType,
    state,
  ];
}
