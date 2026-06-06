import 'package:thimar/core/imports/core_imports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thimar/features/transaction_history/domain/usecases/get_transaction_history_use_case.dart';
import 'package:thimar/features/transaction_history/presentation/bloc/transaction_history_event.dart';
import 'package:thimar/features/transaction_history/presentation/bloc/transaction_history_state.dart';

class TransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final GetTransactionHistoryUseCase getTransactionHistoryUseCase;

  TransactionHistoryBloc({required this.getTransactionHistoryUseCase})
    : super(const TransactionHistoryState()) {
    on<TransactionHistoryLoaded>(_onTransactionHistoryLoaded);
    on<TransactionHistoryFilteredByType>(_onTransactionHistoryFilteredByType);
    on<TransactionHistoryCleared>(_onTransactionHistoryCleared);
  }

  Future<void> _onTransactionHistoryLoaded(
    TransactionHistoryLoaded event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    emit(
      state.copyWith(
        status: TransactionHistoryStatus.loading,
        clearError: true,
      ),
    );

    final result = await getTransactionHistoryUseCase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TransactionHistoryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (transactions) => emit(
        state.copyWith(
          status: TransactionHistoryStatus.success,
          transactions: transactions,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onTransactionHistoryFilteredByType(
    TransactionHistoryFilteredByType event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    final filtered = state.transactions
        .where((tx) => tx.type == event.type)
        .toList();

    emit(state.copyWith(transactions: filtered, selectedFilter: event.type));
  }

  Future<void> _onTransactionHistoryCleared(
    TransactionHistoryCleared event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    final result = await getTransactionHistoryUseCase(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TransactionHistoryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (transactions) => emit(
        state.copyWith(transactions: transactions, selectedFilter: null),
      ),
    );
  }
}
