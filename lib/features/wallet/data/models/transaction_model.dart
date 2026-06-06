import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/wallet/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required String id,
    required double amount,
    required TransactionType type,
    required String description,
    required DateTime date,
  }) : super(
          id: id,
          amount: amount,
          type: type,
          description: description,
          date: date,
        );

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: _parseType(json['type']?.toString() ?? ''),
      description: json['description']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  static TransactionType _parseType(String type) {
    switch (type) {
      case 'deposit':
        return TransactionType.deposit;
      case 'withdrawal':
        return TransactionType.withdrawal;
      case 'payment':
        return TransactionType.payment;
      case 'refund':
        return TransactionType.refund;
      default:
        return TransactionType.payment;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type.name,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      amount: amount,
      type: type,
      description: description,
      date: date,
    );
  }
}
