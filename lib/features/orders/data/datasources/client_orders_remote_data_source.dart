import 'package:thimar/features/orders/data/models/order_model.dart';

abstract class ClientOrdersRemoteDataSource {
  Future<List<OrderModel>> getClientOrders();
}

class ClientOrdersRemoteDataSourceImpl implements ClientOrdersRemoteDataSource {
  ClientOrdersRemoteDataSourceImpl(dynamic apiService);

  @override
  Future<List<OrderModel>> getClientOrders() async {
    return [];
  }
}
