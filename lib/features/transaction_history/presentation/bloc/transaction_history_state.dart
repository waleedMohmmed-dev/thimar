import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/transaction_history/domain/entities/transaction_entity.dart';

enum TransactionHistoryStatus { initial, loading, success, failure }

class TransactionHistoryState extends Equatable {
  final TransactionHistoryStatus status;
  final List<TransactionEntity> transactions;
  final String? errorMessage;
  final TransactionType? selectedFilter;

  const TransactionHistoryState({
    this.status = TransactionHistoryStatus.initial,
    this.transactions = const [],
    this.errorMessage,
    this.selectedFilter,
  });

  TransactionHistoryState copyWith({
    TransactionHistoryStatus? status,
    List<TransactionEntity>? transactions,
    String? errorMessage,
    TransactionType? selectedFilter,
    bool clearError = false,
  }) {
    return TransactionHistoryState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [
    status,
    transactions,
    errorMessage,
    selectedFilter,
  ];
}
