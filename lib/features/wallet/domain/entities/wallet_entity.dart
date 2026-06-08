import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/wallet/domain/entities/transaction_entity.dart';

class WalletEntity extends Equatable {
  final double balance;
  final List<TransactionEntity> transactions;

  const WalletEntity({this.balance = 0.0, this.transactions = const []});

  @override
  List<Object?> get props => [balance, transactions];
}
