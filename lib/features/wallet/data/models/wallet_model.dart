import 'package:thimar/features/wallet/domain/entities/wallet_entity.dart';
import 'package:thimar/features/wallet/data/models/transaction_model.dart';

class WalletModel extends WalletEntity {
  const WalletModel({required super.balance, required super.transactions});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final List transactionsData = json['transactions'] ?? [];
    return WalletModel(
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      transactions: transactionsData
          .map(
            (t) =>
                TransactionModel.fromJson(t as Map<String, dynamic>).toEntity(),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'transactions': transactions
          .map(
            (t) => TransactionModel(
              id: t.id,
              amount: t.amount,
              type: t.type,
              description: t.description,
              date: t.date,
            ).toJson(),
          )
          .toList(),
    };
  }

  WalletEntity toEntity() {
    return WalletEntity(balance: balance, transactions: transactions);
  }
}
