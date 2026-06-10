import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/endpoints.dart';
import 'package:thimar/features/orders/data/models/order_model.dart';

abstract class ClientOrdersRemoteDataSource {
  Future<List<OrderModel>> getCurrentOrders();
  Future<List<OrderModel>> getFinishedOrders();
  Future<List<OrderModel>> getAllOrders();
  Future<OrderModel> getOrderDetails(int orderId);
  Future<List<dynamic>> getOrderProducts(int orderId);
  Future<Map<String, dynamic>> storeOrder(Map<String, dynamic> body);
  Future<Map<String, dynamic>> getDeliveryCost(int addressId);
}

class ClientOrdersRemoteDataSourceImpl implements ClientOrdersRemoteDataSource {
  final ApiService _apiService;

  ClientOrdersRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<OrderModel>> getCurrentOrders() async {
    final response = await _apiService.get(Endpoints.clientCurrentOrders);
    final list = (response['data'] as List? ?? [])
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  @override
  Future<List<OrderModel>> getFinishedOrders() async {
    final response = await _apiService.get(Endpoints.clientFinishedOrders);
    final list = (response['data'] as List? ?? [])
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  @override
  Future<List<OrderModel>> getAllOrders() async {
    final response = await _apiService.get(Endpoints.clientOrders);
    final list = (response['data'] as List? ?? [])
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  @override
  Future<OrderModel> getOrderDetails(int orderId) async {
    final response = await _apiService.get(
      Endpoints.clientOrderDetails(orderId.toString()),
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};
    return OrderModel.fromJson(data);
  }

  @override
  Future<List<dynamic>> getOrderProducts(int orderId) async {
    final response = await _apiService.get(
      Endpoints.clientOrderProducts(orderId.toString()),
    );
    return response['data'] as List? ?? [];
  }

  @override
  Future<Map<String, dynamic>> storeOrder(Map<String, dynamic> body) async {
    final response = await _apiService.post(Endpoints.clientOrders, body: body);
    return response['data'] as Map<String, dynamic>? ?? {};
  }

  @override
  Future<Map<String, dynamic>> getDeliveryCost(int addressId) async {
    final response = await _apiService.get(
      Endpoints.clientDeliveryCost,
      params: {'address_id': addressId.toString()},
    );
    return response['data'] as Map<String, dynamic>? ?? {};
  }
}
