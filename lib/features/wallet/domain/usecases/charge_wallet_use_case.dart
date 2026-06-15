import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/wallet/domain/repositories/wallet_repository.dart';

class ChargeWalletParams {
  final double amount;
  final String transactionId;
  const ChargeWalletParams({required this.amount, required this.transactionId});
}

class ChargeWalletUseCase
    implements UseCase<Map<String, dynamic>, ChargeWalletParams> {
  final WalletRepository repository;

  ChargeWalletUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    ChargeWalletParams params,
  ) async {
    return repository.chargeWallet(
      amount: params.amount,
      transactionId: params.transactionId,
    );
  }
}
