import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';

enum OrderDetailsStatus { initial, loading, success, failure }

class OrderDetailsState extends Equatable {
  final OrderDetailsStatus detailsStatus;
  final OrderStatus? status;
  final OrderEntity? order;
  final String? errorMessage;
  final bool isAccepting;
  final String? acceptError;
  final String? acceptSuccessMessage;
  final bool isRejecting;
  final String? rejectError;
  final String? rejectSuccessMessage;
  final bool isStartingDelivery;
  final String? startDeliveryError;
  final String? startDeliverySuccessMessage;
  final bool isFinishing;
  final String? finishError;
  final String? finishSuccessMessage;

  const OrderDetailsState({
    this.detailsStatus = OrderDetailsStatus.initial,
    this.status,
    this.order,
    this.errorMessage,
    this.isAccepting = false,
    this.acceptError,
    this.acceptSuccessMessage,
    this.isRejecting = false,
    this.rejectError,
    this.rejectSuccessMessage,
    this.isStartingDelivery = false,
    this.startDeliveryError,
    this.startDeliverySuccessMessage,
    this.isFinishing = false,
    this.finishError,
    this.finishSuccessMessage,
  });

  OrderDetailsState copyWith({
    OrderDetailsStatus? detailsStatus,
    OrderStatus? status,
    bool clearStatus = false,
    OrderEntity? order,
    String? errorMessage,
    bool clearError = false,
    bool? isAccepting,
    String? acceptError,
    bool clearAcceptError = false,
    String? acceptSuccessMessage,
    bool clearAcceptSuccess = false,
    bool? isRejecting,
    String? rejectError,
    bool clearRejectError = false,
    String? rejectSuccessMessage,
    bool clearRejectSuccess = false,
    bool? isStartingDelivery,
    String? startDeliveryError,
    bool clearStartDeliveryError = false,
    String? startDeliverySuccessMessage,
    bool clearStartDeliverySuccess = false,
    bool? isFinishing,
    String? finishError,
    bool clearFinishError = false,
    String? finishSuccessMessage,
    bool clearFinishSuccess = false,
  }) {
    return OrderDetailsState(
      detailsStatus: detailsStatus ?? this.detailsStatus,
      status: clearStatus ? null : status ?? this.status,
      order: order ?? this.order,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isAccepting: isAccepting ?? this.isAccepting,
      acceptError: clearAcceptError ? null : acceptError ?? this.acceptError,
      acceptSuccessMessage: clearAcceptSuccess
          ? null
          : acceptSuccessMessage ?? this.acceptSuccessMessage,
      isRejecting: isRejecting ?? this.isRejecting,
      rejectError: clearRejectError ? null : rejectError ?? this.rejectError,
      rejectSuccessMessage: clearRejectSuccess
          ? null
          : rejectSuccessMessage ?? this.rejectSuccessMessage,
      isStartingDelivery: isStartingDelivery ?? this.isStartingDelivery,
      startDeliveryError: clearStartDeliveryError
          ? null
          : startDeliveryError ?? this.startDeliveryError,
      startDeliverySuccessMessage: clearStartDeliverySuccess
          ? null
          : startDeliverySuccessMessage ?? this.startDeliverySuccessMessage,
      isFinishing: isFinishing ?? this.isFinishing,
      finishError: clearFinishError ? null : finishError ?? this.finishError,
      finishSuccessMessage: clearFinishSuccess
          ? null
          : finishSuccessMessage ?? this.finishSuccessMessage,
    );
  }

  @override
  List<Object?> get props => [
    detailsStatus,
    status,
    order,
    errorMessage,
    isAccepting,
    acceptError,
    acceptSuccessMessage,
    isRejecting,
    rejectError,
    rejectSuccessMessage,
    isStartingDelivery,
    startDeliveryError,
    startDeliverySuccessMessage,
    isFinishing,
    finishError,
    finishSuccessMessage,
  ];
}
