import 'package:bloc/bloc.dart';
import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/wallet/domain/entities/wallet_transaction_entity.dart';
import 'package:thimar/features/wallet/domain/usecases/cashout_wallet_use_case.dart';
import 'package:thimar/features/wallet/domain/usecases/charge_wallet_use_case.dart';
import 'package:thimar/features/wallet/domain/usecases/get_wallet_balance_use_case.dart';
import 'package:thimar/features/wallet/domain/usecases/get_wallet_transactions_use_case.dart';

enum WalletStatus { initial, loading, success, failure }

class WalletState extends Equatable {
  final WalletStatus status;
  final WalletStatus chargeStatus;
  final WalletStatus cashoutStatus;
  final double balance;
  final List<WalletTransactionEntity> transactions;
  final String? errorMessage;
  final String? chargeSuccessMessage;
  final String? cashoutSuccessMessage;

  const WalletState({
    this.status = WalletStatus.initial,
    this.chargeStatus = WalletStatus.initial,
    this.cashoutStatus = WalletStatus.initial,
    this.balance = 0,
    this.transactions = const [],
    this.errorMessage,
    this.chargeSuccessMessage,
    this.cashoutSuccessMessage,
  });

  WalletState copyWith({
    WalletStatus? status,
    WalletStatus? chargeStatus,
    WalletStatus? cashoutStatus,
    double? balance,
    List<WalletTransactionEntity>? transactions,
    String? errorMessage,
    String? chargeSuccessMessage,
    String? cashoutSuccessMessage,
    bool? clearError,
    bool? clearChargeSuccess,
    bool? clearCashoutSuccess,
  }) {
    return WalletState(
      status: status ?? this.status,
      chargeStatus: chargeStatus ?? this.chargeStatus,
      cashoutStatus: cashoutStatus ?? this.cashoutStatus,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      errorMessage: clearError == true ? null : errorMessage ?? this.errorMessage,
      chargeSuccessMessage: clearChargeSuccess == true
          ? null
          : chargeSuccessMessage ?? this.chargeSuccessMessage,
      cashoutSuccessMessage: clearCashoutSuccess == true
          ? null
          : cashoutSuccessMessage ?? this.cashoutSuccessMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    chargeStatus,
    cashoutStatus,
    balance,
    transactions,
    errorMessage,
    chargeSuccessMessage,
    cashoutSuccessMessage,
  ];
}

abstract class WalletEvent extends Equatable {
  const WalletEvent();
  @override
  List<Object?> get props => [];
}

class WalletLoadRequested extends WalletEvent {
  const WalletLoadRequested();
}

class WalletChargeRequested extends WalletEvent {
  final double amount;
  final String transactionId;
  const WalletChargeRequested({
    required this.amount,
    required this.transactionId,
  });
  @override
  List<Object?> get props => [amount, transactionId];
}

class WalletCashoutRequested extends WalletEvent {
  final double amount;
  const WalletCashoutRequested({required this.amount});
  @override
  List<Object?> get props => [amount];
}

class WalletClearMessages extends WalletEvent {
  const WalletClearMessages();
}

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletBalanceUseCase _getWalletBalanceUseCase;
  final GetWalletTransactionsUseCase _getWalletTransactionsUseCase;
  final ChargeWalletUseCase _chargeWalletUseCase;
  final CashoutWalletUseCase _cashoutWalletUseCase;

  WalletBloc({
    required GetWalletBalanceUseCase getWalletBalanceUseCase,
    required GetWalletTransactionsUseCase getWalletTransactionsUseCase,
    required ChargeWalletUseCase chargeWalletUseCase,
    required CashoutWalletUseCase cashoutWalletUseCase,
  }) : _getWalletBalanceUseCase = getWalletBalanceUseCase,
       _getWalletTransactionsUseCase = getWalletTransactionsUseCase,
       _chargeWalletUseCase = chargeWalletUseCase,
       _cashoutWalletUseCase = cashoutWalletUseCase,
       super(const WalletState()) {
    on<WalletLoadRequested>(_onLoad);
    on<WalletChargeRequested>(_onCharge);
    on<WalletCashoutRequested>(_onCashout);
    on<WalletClearMessages>(_onClearMessages);
  }

  Future<void> _onLoad(
    WalletLoadRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading, clearError: true));
    await _loadData(emit);
  }

  Future<void> _loadData(Emitter<WalletState> emit) async {
    final results = await Future.wait([
      _getWalletBalanceUseCase(const NoParams()),
      _getWalletTransactionsUseCase(const NoParams()),
    ]);

    if (isClosed) return;

    double balance = 0;
    List<WalletTransactionEntity> transactions = [];
    String? error;

    for (final result in results) {
      result.fold(
        (failure) => error = failure.message,
        (value) {
          if (value is double) {
            balance = value;
          } else if (value is List<WalletTransactionEntity>) {
            transactions = value;
          }
        },
      );
    }

    if (error != null) {
      emit(state.copyWith(
        status: WalletStatus.failure,
        errorMessage: error,
      ));
    } else {
      emit(state.copyWith(
        status: WalletStatus.success,
        balance: balance,
        transactions: transactions,
      ));
    }
  }

  Future<void> _onCharge(
    WalletChargeRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(
      chargeStatus: WalletStatus.loading,
      clearChargeSuccess: true,
      clearError: true,
    ));

    final result = await _chargeWalletUseCase(
      ChargeWalletParams(
        amount: event.amount,
        transactionId: event.transactionId,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        chargeStatus: WalletStatus.failure,
        errorMessage: failure.message,
      )),
      (data) {
        final message = data['message']?.toString() ?? 'تم شحن المحفظة بنجاح';
        emit(state.copyWith(
          chargeStatus: WalletStatus.success,
          chargeSuccessMessage: message,
        ));
        add(const WalletLoadRequested());
      },
    );
  }

  Future<void> _onCashout(
    WalletCashoutRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(
      cashoutStatus: WalletStatus.loading,
      clearCashoutSuccess: true,
      clearError: true,
    ));

    final result = await _cashoutWalletUseCase(event.amount);

    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        cashoutStatus: WalletStatus.failure,
        errorMessage: failure.message,
      )),
      (data) {
        emit(state.copyWith(
          cashoutStatus: WalletStatus.success,
          cashoutSuccessMessage: 'تم السحب بنجاح',
        ));
        add(const WalletLoadRequested());
      },
    );
  }

  void _onClearMessages(
    WalletClearMessages event,
    Emitter<WalletState> emit,
  ) {
    emit(state.copyWith(
      clearChargeSuccess: true,
      clearCashoutSuccess: true,
      clearError: true,
    ));
  }
}
