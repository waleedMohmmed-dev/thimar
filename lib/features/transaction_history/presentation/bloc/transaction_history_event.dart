import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/transaction_history/domain/entities/transaction_entity.dart';

abstract class TransactionHistoryEvent extends Equatable {
  const TransactionHistoryEvent();

  @override
  List<Object?> get props => [];
}

class TransactionHistoryLoaded extends TransactionHistoryEvent {
  const TransactionHistoryLoaded();
}

class TransactionHistoryFilteredByType extends TransactionHistoryEvent {
  final TransactionType type;
  const TransactionHistoryFilteredByType(this.type);

  @override
  List<Object?> get props => [type];
}

class TransactionHistoryCleared extends TransactionHistoryEvent {
  const TransactionHistoryCleared();
}
