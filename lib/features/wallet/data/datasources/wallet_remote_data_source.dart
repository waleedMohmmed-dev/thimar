import 'package:thimar/features/wallet/data/models/wallet_model.dart';

abstract class WalletRemoteDataSource {
  Future<WalletModel> getWallet();
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  WalletRemoteDataSourceImpl(dynamic apiService);

  @override
  Future<WalletModel> getWallet() async {
    throw UnimplementedError('Client feature disabled');
  }
}
