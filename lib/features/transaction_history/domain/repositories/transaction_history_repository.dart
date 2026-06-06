import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/transaction_history/domain/entities/transaction_entity.dart';

abstract class TransactionHistoryRepository {
  Future<Either<Failure, List<TransactionEntity>>> getTransactionHistory();
  Future<Either<Failure, List<TransactionEntity>>> getTransactionHistoryByType(
    TransactionType type,
  );
  Future<Either<Failure, TransactionEntity>> getTransactionDetails(
    String transactionId,
  );
}
