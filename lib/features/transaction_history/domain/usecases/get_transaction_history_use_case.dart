import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/transaction_history/domain/entities/transaction_entity.dart';
import 'package:thimar/features/transaction_history/domain/repositories/transaction_history_repository.dart';

class GetTransactionHistoryUseCase
    implements UseCase<List<TransactionEntity>, NoParams> {
  final TransactionHistoryRepository repository;

  GetTransactionHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<TransactionEntity>>> call(NoParams params) {
    return repository.getTransactionHistory();
  }
}
