import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/usecases/get_client_current_orders_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/get_client_finished_orders_use_case.dart';

part 'client_orders_state.dart';

class ClientOrdersBloc extends Bloc<ClientOrdersEvent, ClientOrdersState> {
  final GetClientCurrentOrdersUseCase _getClientCurrentOrdersUseCase;
  final GetClientFinishedOrdersUseCase _getClientFinishedOrdersUseCase;

  ClientOrdersBloc({
    required GetClientCurrentOrdersUseCase getClientCurrentOrdersUseCase,
    required GetClientFinishedOrdersUseCase getClientFinishedOrdersUseCase,
  }) : _getClientCurrentOrdersUseCase = getClientCurrentOrdersUseCase,
       _getClientFinishedOrdersUseCase = getClientFinishedOrdersUseCase,
       super(const ClientOrdersState()) {
    on<ClientCurrentOrdersRequested>(_onClientCurrentOrdersRequested);
    on<ClientFinishedOrdersRequested>(_onClientFinishedOrdersRequested);
    on<ClientOrdersTabChanged>(_onClientOrdersTabChanged);
  }

  Future<void> _onClientCurrentOrdersRequested(
    ClientCurrentOrdersRequested event,
    Emitter<ClientOrdersState> emit,
  ) async {
    emit(state.copyWith(currentStatus: ClientOrdersStatus.loading, clearError: true));

    final result = await _getClientCurrentOrdersUseCase(const NoParams());

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          currentStatus: ClientOrdersStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (orders) => emit(
        state.copyWith(
          currentStatus: ClientOrdersStatus.success,
          currentOrders: orders,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onClientFinishedOrdersRequested(
    ClientFinishedOrdersRequested event,
    Emitter<ClientOrdersState> emit,
  ) async {
    emit(state.copyWith(finishedStatus: ClientOrdersStatus.loading, clearError: true));

    final result = await _getClientFinishedOrdersUseCase(const NoParams());

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          finishedStatus: ClientOrdersStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (orders) => emit(
        state.copyWith(
          finishedStatus: ClientOrdersStatus.success,
          finishedOrders: orders,
          clearError: true,
        ),
      ),
    );
  }

  void _onClientOrdersTabChanged(
    ClientOrdersTabChanged event,
    Emitter<ClientOrdersState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.tab));
  }
}
