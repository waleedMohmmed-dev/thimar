import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/transaction_history/domain/entities/transaction_entity.dart';
import 'package:thimar/features/transaction_history/domain/repositories/transaction_history_repository.dart';

class GetTransactionDetailsUseCase
    implements UseCase<TransactionEntity, String> {
  final TransactionHistoryRepository repository;

  GetTransactionDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, TransactionEntity>> call(String transactionId) {
    return repository.getTransactionDetails(transactionId);
  }
}
