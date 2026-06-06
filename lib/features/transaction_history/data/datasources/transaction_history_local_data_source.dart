import 'package:thimar/features/transaction_history/data/models/transaction_model.dart';

abstract class TransactionHistoryLocalDataSource {
  Future<List<TransactionModel>> getTransactionHistory();
  Future<List<TransactionModel>> getTransactionHistoryByType(String type);
  Future<TransactionModel> getTransactionDetails(String transactionId);
}

class TransactionHistoryLocalDataSourceImpl
    implements TransactionHistoryLocalDataSource {
  @override
  Future<List<TransactionModel>> getTransactionHistory() async {
    // Mock data - in real app, this would come from local database or API
    return [
      TransactionModel(
        id: '1',
        type: 'order_payment',
        amount: 180.0,
        dateTime: DateTime(2021, 6, 27).toIso8601String(),
        description: 'دفعت مقابل هذا الطلب',
        orderId: '4587',
        productImagePaths: [
          'assets/images/watermelon.jpg',
          'assets/images/carrot.jpg',
          'assets/images/tomato.jpg',
        ],
        extraProductsCount: 2,
        isIncome: false,
      ),
      TransactionModel(
        id: '2',
        type: 'wallet_top_up',
        amount: 255.0,
        dateTime: DateTime(2021, 6, 27).toIso8601String(),
        description: 'شحن المحفظة',
        isIncome: true,
      ),
      TransactionModel(
        id: '3',
        type: 'wallet_top_up',
        amount: 255.0,
        dateTime: DateTime(2021, 6, 27).toIso8601String(),
        description: 'شحن المحفظة',
        isIncome: true,
      ),
      TransactionModel(
        id: '4',
        type: 'order_payment',
        amount: 180.0,
        dateTime: DateTime(2021, 6, 27).toIso8601String(),
        description: 'دفعت مقابل هذا الطلب',
        orderId: '4587',
        productImagePaths: [
          'assets/images/watermelon.jpg',
          'assets/images/carrot.jpg',
          'assets/images/tomato.jpg',
        ],
        extraProductsCount: 2,
        isIncome: false,
      ),
      TransactionModel(
        id: '5',
        type: 'wallet_top_up',
        amount: 255.0,
        dateTime: DateTime(2021, 6, 27).toIso8601String(),
        description: 'شحن المحفظة',
        isIncome: true,
      ),
    ];
  }

  @override
  Future<List<TransactionModel>> getTransactionHistoryByType(
    String type,
  ) async {
    final allTransactions = await getTransactionHistory();
    return allTransactions.where((tx) => tx.type == type).toList();
  }

  @override
  Future<TransactionModel> getTransactionDetails(String transactionId) async {
    final transactions = await getTransactionHistory();
    return transactions.firstWhere(
      (tx) => tx.id == transactionId,
      orElse: () => transactions.first,
    );
  }
}
