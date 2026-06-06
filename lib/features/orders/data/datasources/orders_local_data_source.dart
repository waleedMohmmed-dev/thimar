import 'package:thimar/features/orders/data/models/order_model.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';

abstract class OrdersLocalDataSource {
  Future<List<OrderModel>> getCurrentOrders();

  Future<List<OrderModel>> getFinishedOrders();
}

class OrdersLocalDataSourceImpl implements OrdersLocalDataSource {
  static const List<String> _previewImages = [
    'assets/images/fruit.png',
    'assets/images/vegetable.png',
    'assets/images/spices.png',
  ];

  @override
  Future<List<OrderModel>> getCurrentOrders() async {
    return const [
      OrderModel(
        id: '4587',
        dateKey: 'order_date_sample',
        total: 180,
        status: OrderStatus.pendingApproval,
        productImagePaths: _previewImages,
        extraProductsCount: 2,
      ),
      OrderModel(
        id: '4588',
        dateKey: 'order_date_sample',
        total: 180,
        status: OrderStatus.preparing,
        productImagePaths: _previewImages,
        extraProductsCount: 2,
      ),
      OrderModel(
        id: '4589',
        dateKey: 'order_date_sample',
        total: 180,
        status: OrderStatus.onWay,
        productImagePaths: _previewImages,
        extraProductsCount: 2,
      ),
      OrderModel(
        id: '4590',
        dateKey: 'order_date_sample',
        total: 180,
        status: OrderStatus.pendingApproval,
        productImagePaths: _previewImages,
        extraProductsCount: 2,
      ),
    ];
  }

  @override
  Future<List<OrderModel>> getFinishedOrders() async {
    return const [
      OrderModel(
        id: '4578',
        dateKey: 'order_date_sample',
        total: 165,
        status: OrderStatus.delivered,
        productImagePaths: _previewImages,
        extraProductsCount: 1,
      ),
      OrderModel(
        id: '4577',
        dateKey: 'order_date_sample',
        total: 92,
        status: OrderStatus.cancelled,
        productImagePaths: _previewImages,
      ),
      OrderModel(
        id: '4576',
        dateKey: 'order_date_sample',
        total: 210,
        status: OrderStatus.delivered,
        productImagePaths: _previewImages,
        extraProductsCount: 3,
      ),
    ];
  }
}
