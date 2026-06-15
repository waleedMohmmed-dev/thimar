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
    return [];
  }

  @override
  Future<List<TransactionModel>> getTransactionHistoryByType(
    String type,
  ) async {
    return [];
  }

  @override
  Future<TransactionModel> getTransactionDetails(String transactionId) async {
    return const TransactionModel(
      id: 0,
      amount: 0,
      beforeCharge: 0,
      afterCharge: 0,
      date: '',
      statusTrans: '',
      status: '',
      transactionType: '',
      state: '',
    );
  }
}
