import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/wallet/domain/repositories/wallet_repository.dart';

class CashoutWalletUseCase implements UseCase<Map<String, dynamic>, double> {
  final WalletRepository repository;

  CashoutWalletUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(double amount) async {
    return repository.cashoutWallet(amount);
  }
}
