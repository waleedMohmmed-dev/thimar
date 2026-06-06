import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/endpoints.dart';
import 'package:thimar/features/orders/data/models/order_model.dart';
import 'package:thimar/features/orders/data/models/order_details_model.dart';
import 'package:thimar/features/orders/data/models/current_order_search_model.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderModel>> getPendingOrders();
  Future<List<OrderModel>> getCurrentOrders();
  Future<({List<OrderModel> orders, bool hasMore})> getFinishedOrders({
    int page = 1,
  });
  Future<List<CurrentOrderSearchModel>> searchCurrentOrders(String keyword);
  Future<List<CurrentOrderSearchModel>> searchFinishedOrders(String keyword);
  Future<String> refuseOrder(String orderId);
  Future<OrderDetailsModel> getOrderDetails(String orderId);
  Future<String> acceptOrder(String orderId);
  Future<String> startDeliveringOrder(String orderId);
  Future<String> finishOrder(String orderId, double clientPaidAmount);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final ApiService _apiService;

  OrdersRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<OrderModel>> getPendingOrders() async {
    final response = await _apiService.get(Endpoints.driverPendingOrders);
    final List data = response['data'] ?? [];
    return data.map((json) => OrderModel.fromJson(json)).toList();
  }

  @override
  Future<List<OrderModel>> getCurrentOrders() async {
    final response = await _apiService.get(Endpoints.driverCurrentOrders);
    final List data = response['data'] ?? [];
    return data.map((json) => OrderModel.fromJson(json)).toList();
  }

  @override
  Future<({List<OrderModel> orders, bool hasMore})> getFinishedOrders({
    int page = 1,
  }) async {
    final response = await _apiService.get(
      Endpoints.driverFinishedOrders,
      params: {'page': page},
    );
    final List data = response['data'] ?? [];
    final orders = data.map((json) => OrderModel.fromJson(json)).toList();

    final links = response['links'] as Map<String, dynamic>?;
    final hasMore = links?['next'] != null;

    return (orders: orders, hasMore: hasMore);
  }

  @override
  Future<List<CurrentOrderSearchModel>> searchCurrentOrders(
    String keyword,
  ) async {
    final response = await _apiService.get(
      Endpoints.driverSearchCurrent,
      params: {'keyword': keyword},
    );
    final List data = response['data'] ?? [];
    return data.map((json) => CurrentOrderSearchModel.fromJson(json)).toList();
  }

  @override
  Future<List<CurrentOrderSearchModel>> searchFinishedOrders(
    String keyword,
  ) async {
    final response = await _apiService.get(
      Endpoints.driverSearch,
      params: {'keyword': keyword},
    );
    final List data = response['data'] ?? [];
    return data.map((json) => CurrentOrderSearchModel.fromJson(json)).toList();
  }

  @override
  Future<String> refuseOrder(String orderId) async {
    final response = await _apiService.post(
      '${Endpoints.driverRefuseOrder}/$orderId',
    );
    return response['message']?.toString() ?? '';
  }

  @override
  Future<OrderDetailsModel> getOrderDetails(String orderId) async {
    final response = await _apiService.get(
      '${Endpoints.orderDetails}/$orderId',
    );
    final data = response['data'];
    if (data == null || data is! Map<String, dynamic>) {
      return const OrderDetailsModel(
        id: '',
        status: '',
        date: '',
        time: '',
        orderPrice: 0,
        deliveryPrice: 0,
        totalPrice: 0,
        clientName: '',
        clientPhone: '',
        clientImage: '',
        address: '',
      );
    }
    return OrderDetailsModel.fromJson(data);
  }

  @override
  Future<String> acceptOrder(String orderId) async {
    final response = await _apiService.post(
      '${Endpoints.driverAcceptOrder}/$orderId',
    );
    return response['message']?.toString() ?? '';
  }

  @override
  Future<String> startDeliveringOrder(String orderId) async {
    final response = await _apiService.post(
      '${Endpoints.driverStartDelivering}/$orderId',
    );
    return response['message']?.toString() ?? '';
  }

  @override
  Future<String> finishOrder(String orderId, double clientPaidAmount) async {
    final response = await _apiService.post(
      '${Endpoints.driverFinishOrder}/$orderId',
      body: {'client_paid_amount': clientPaidAmount},
    );
    return response['message']?.toString() ?? '';
  }
}
