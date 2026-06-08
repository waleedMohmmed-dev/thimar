import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/transaction_history/domain/entities/transaction_entity.dart';

class TransactionModel extends Equatable {
  final String id;
  final String type;
  final double amount;
  final String dateTime;
  final String? description;
  final String? orderId;
  final List<String>? productImagePaths;
  final int? extraProductsCount;
  final bool isIncome;

  const TransactionModel({
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

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final typeMap = {
      'wallet_top_up': 'wallet_top_up',
      'order_payment': 'order_payment',
      'wallet_withdraw': 'wallet_withdraw',
      'refund': 'refund',
      'bonus': 'bonus',
      'charge': 'wallet_top_up',
      'cashout': 'wallet_withdraw',
    };
    final rawType = json['type']?.toString() ?? 'order_payment';
    final mappedType = typeMap[rawType] ?? rawType;

    return TransactionModel(
      id: json['id']?.toString() ?? '',
      type: mappedType,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      dateTime:
          json['date']?.toString() ??
          json['created_at']?.toString() ??
          DateTime.now().toIso8601String(),
      description: json['description']?.toString(),
      orderId: json['order_id']?.toString() ?? json['orderId']?.toString(),
      productImagePaths: json['products'] != null
          ? (json['products'] as List)
                .map((p) => p['url']?.toString() ?? '')
                .where((u) => u.isNotEmpty)
                .toList()
          : null,
      extraProductsCount: json['extra_products_count'] as int?,
      isIncome: json['is_income'] ?? json['isIncome'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'dateTime': dateTime,
      'description': description,
      'orderId': orderId,
      'productImagePaths': productImagePaths,
      'extraProductsCount': extraProductsCount,
      'isIncome': isIncome,
    };
  }

  TransactionEntity toEntity() {
    final typeMap = {
      'wallet_top_up': TransactionType.walletTopUp,
      'order_payment': TransactionType.orderPayment,
      'wallet_withdraw': TransactionType.walletWithdraw,
      'refund': TransactionType.refund,
      'bonus': TransactionType.bonus,
    };

    return TransactionEntity(
      id: id,
      type: typeMap[type] ?? TransactionType.orderPayment,
      amount: amount,
      dateTime: DateTime.parse(dateTime),
      description: description,
      orderId: orderId,
      productImagePaths: productImagePaths,
      extraProductsCount: extraProductsCount,
      isIncome: isIncome,
    );
  }

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
