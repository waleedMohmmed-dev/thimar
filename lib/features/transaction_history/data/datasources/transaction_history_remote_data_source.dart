import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/endpoints.dart';
import 'package:thimar/features/transaction_history/data/models/transaction_model.dart';

abstract class TransactionHistoryRemoteDataSource {
  Future<List<TransactionModel>> getTransactionHistory();
  Future<List<TransactionModel>> getTransactionHistoryByType(String type);
}

class TransactionHistoryRemoteDataSourceImpl
    implements TransactionHistoryRemoteDataSource {
  final ApiService _apiService;

  TransactionHistoryRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<TransactionModel>> getTransactionHistory() async {
    final response = await _apiService.get(Endpoints.walletTransactions);
    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((json) => TransactionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionHistoryByType(
    String type,
  ) async {
    final response = await _apiService.get(
      Endpoints.walletTransactions,
      params: {'type': type},
    );
    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((json) => TransactionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
