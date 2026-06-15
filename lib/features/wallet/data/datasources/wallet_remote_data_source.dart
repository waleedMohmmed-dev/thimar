import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/endpoints.dart';
import 'package:thimar/features/wallet/data/models/wallet_transaction_model.dart';

class WalletRemoteDataSource {
  final ApiService _apiService;

  WalletRemoteDataSource(this._apiService);

  Future<Map<String, dynamic>> chargeWallet({
    required double amount,
    required String transactionId,
  }) async {
    final response = await _apiService.post(
      Endpoints.walletCharge,
      body: {'amount': amount, 'transaction_id': transactionId},
    );
    return response as Map<String, dynamic>? ?? {};
  }

  Future<Map<String, dynamic>> getWallet() async {
    final response = await _apiService.get(Endpoints.wallet);
    return response as Map<String, dynamic>? ?? {};
  }

  Future<List<WalletTransactionModel>> getWalletTransactions() async {
    final response = await _apiService.get(Endpoints.walletTransactions);
    final data = response['data'] as List? ?? [];
    return data
        .map((e) => WalletTransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> cashoutWallet(double amount) async {
    final response = await _apiService.post(
      Endpoints.walletCashout,
      body: {'amount': amount},
    );
    return response as Map<String, dynamic>? ?? {};
  }
}
