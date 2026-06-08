import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/usecases/get_client_orders_use_case.dart';

part 'client_orders_state.dart';

class ClientOrdersBloc extends Bloc<ClientOrdersEvent, ClientOrdersState> {
  final GetClientOrdersUseCase _getClientOrdersUseCase;

  ClientOrdersBloc({required GetClientOrdersUseCase getClientOrdersUseCase})
    : _getClientOrdersUseCase = getClientOrdersUseCase,
      super(const ClientOrdersState()) {
    on<ClientOrdersStarted>(_onClientOrdersStarted);
  }

  Future<void> _onClientOrdersStarted(
    ClientOrdersStarted event,
    Emitter<ClientOrdersState> emit,
  ) async {
    emit(state.copyWith(status: ClientOrdersStatus.loading, clearError: true));

    final result = await _getClientOrdersUseCase(const NoParams());

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ClientOrdersStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (orders) => emit(
        state.copyWith(
          status: ClientOrdersStatus.success,
          orders: orders,
          clearError: true,
        ),
      ),
    );
  }
}
