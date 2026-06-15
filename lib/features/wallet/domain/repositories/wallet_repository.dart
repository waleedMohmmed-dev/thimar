import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/wallet/domain/entities/wallet_transaction_entity.dart';

abstract class WalletRepository {
  Future<Either<Failure, Map<String, dynamic>>> chargeWallet({
    required double amount,
    required String transactionId,
  });
  Future<Either<Failure, double>> getWalletBalance();
  Future<Either<Failure, List<WalletTransactionEntity>>> getWalletTransactions();
  Future<Either<Failure, Map<String, dynamic>>> cashoutWallet(double amount);
}
