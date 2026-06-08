import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/usecases/get_order_details_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/accept_order_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/refuse_order_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/start_delivering_order_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/finish_order_use_case.dart';
import 'package:thimar/features/orders/presentation/bloc/order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final GetOrderDetailsUseCase _getOrderDetailsUseCase;
  final AcceptOrderUseCase _acceptOrderUseCase;
  final RefuseOrderUseCase _refuseOrderUseCase;
  final StartDeliveringOrderUseCase _startDeliveringOrderUseCase;
  final FinishOrderUseCase _finishOrderUseCase;

  OrderDetailsCubit({
    required GetOrderDetailsUseCase getOrderDetailsUseCase,
    required AcceptOrderUseCase acceptOrderUseCase,
    required RefuseOrderUseCase refuseOrderUseCase,
    required StartDeliveringOrderUseCase startDeliveringOrderUseCase,
    required FinishOrderUseCase finishOrderUseCase,
    OrderStatus? initialStatus,
    OrderEntity? initialOrder,
  }) : _getOrderDetailsUseCase = getOrderDetailsUseCase,
       _acceptOrderUseCase = acceptOrderUseCase,
       _refuseOrderUseCase = refuseOrderUseCase,
       _startDeliveringOrderUseCase = startDeliveringOrderUseCase,
       _finishOrderUseCase = finishOrderUseCase,
       super(OrderDetailsState(status: initialStatus, order: initialOrder));

  void loadOrderDetails(String orderId) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        detailsStatus: OrderDetailsStatus.loading,
        clearError: true,
      ),
    );

    final result = await _getOrderDetailsUseCase(orderId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          detailsStatus: OrderDetailsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (order) => emit(
        state.copyWith(
          detailsStatus: OrderDetailsStatus.success,
          order: order,
          status: order.status,
        ),
      ),
    );
  }

  void acceptOrder(String orderId) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        isAccepting: true,
        clearAcceptError: true,
        clearAcceptSuccess: true,
      ),
    );

    final result = await _acceptOrderUseCase(orderId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(isAccepting: false, acceptError: failure.message),
      ),
      (message) => emit(
        state.copyWith(
          isAccepting: false,
          status: OrderStatus.preparing,
          acceptSuccessMessage: message,
        ),
      ),
    );
  }

  void startDeliveringOrder(String orderId) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        isStartingDelivery: true,
        clearStartDeliveryError: true,
        clearStartDeliverySuccess: true,
      ),
    );

    final result = await _startDeliveringOrderUseCase(orderId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          isStartingDelivery: false,
          startDeliveryError: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          isStartingDelivery: false,
          status: OrderStatus.onWay,
          startDeliverySuccessMessage: message,
        ),
      ),
    );
  }

  void finishOrder(String orderId, double clientPaidAmount) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        isFinishing: true,
        clearFinishError: true,
        clearFinishSuccess: true,
      ),
    );

    final result = await _finishOrderUseCase(orderId, clientPaidAmount);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(isFinishing: false, finishError: failure.message),
      ),
      (message) => emit(
        state.copyWith(
          isFinishing: false,
          status: OrderStatus.delivered,
          finishSuccessMessage: message,
        ),
      ),
    );
  }

  void rejectOrder(String orderId) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        isRejecting: true,
        clearRejectError: true,
        clearRejectSuccess: true,
      ),
    );

    final result = await _refuseOrderUseCase(orderId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(isRejecting: false, rejectError: failure.message),
      ),
      (message) => emit(
        state.copyWith(
          isRejecting: false,
          status: OrderStatus.cancelled,
          rejectSuccessMessage: message,
        ),
      ),
    );
  }
}
