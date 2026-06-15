import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/wallet/domain/entities/wallet_transaction_entity.dart';
import 'package:thimar/features/wallet/domain/repositories/wallet_repository.dart';

class GetWalletTransactionsUseCase
    implements UseCase<List<WalletTransactionEntity>, NoParams> {
  final WalletRepository repository;

  GetWalletTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<WalletTransactionEntity>>> call(
    NoParams params,
  ) async {
    return repository.getWalletTransactions();
  }
}
