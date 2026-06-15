import 'package:thimar/core/imports/packages_imports.dart';

class WalletTransactionEntity extends Equatable {
  final int id;
  final double amount;
  final double beforeCharge;
  final double afterCharge;
  final String date;
  final String statusTrans;
  final String transactionType;
  final String state;

  const WalletTransactionEntity({
    required this.id,
    required this.amount,
    required this.beforeCharge,
    required this.afterCharge,
    required this.date,
    required this.statusTrans,
    required this.transactionType,
    required this.state,
  });

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
