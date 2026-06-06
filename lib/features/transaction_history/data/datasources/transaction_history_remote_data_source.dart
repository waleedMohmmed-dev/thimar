import 'package:thimar/features/transaction_history/data/models/transaction_model.dart';

abstract class TransactionHistoryRemoteDataSource {
  Future<List<TransactionModel>> getTransactionHistory();
  Future<List<TransactionModel>> getTransactionHistoryByType(String type);
}

class TransactionHistoryRemoteDataSourceImpl
    implements TransactionHistoryRemoteDataSource {
  TransactionHistoryRemoteDataSourceImpl(dynamic apiService);

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
}
