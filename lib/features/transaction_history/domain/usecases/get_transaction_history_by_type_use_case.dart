import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/transaction_history/domain/entities/transaction_entity.dart';
import 'package:thimar/features/transaction_history/domain/repositories/transaction_history_repository.dart';

class GetTransactionHistoryByTypeUseCase
    implements UseCase<List<TransactionEntity>, TransactionType> {
  final TransactionHistoryRepository repository;

  GetTransactionHistoryByTypeUseCase(this.repository);

  @override
  Future<Either<Failure, List<TransactionEntity>>> call(
    TransactionType params,
  ) {
    return repository.getTransactionHistoryByType(params);
  }
}
