import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/wallet/domain/usecases/get_wallet_use_case.dart';
import 'package:thimar/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:thimar/features/wallet/presentation/bloc/wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletUseCase _getWalletUseCase;

  WalletBloc({
    required GetWalletUseCase getWalletUseCase,
  })  : _getWalletUseCase = getWalletUseCase,
        super(const WalletState()) {
    on<WalletFetched>(_onWalletFetched);
  }

  Future<void> _onWalletFetched(
    WalletFetched event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _getWalletUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (wallet) => emit(state.copyWith(
        isLoading: false,
        wallet: wallet,
      )),
    );
  }
}
