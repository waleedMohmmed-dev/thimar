import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';

class OrderModel extends Equatable {
  final String id;
  final String dateKey;
  final double total;
  final OrderStatus status;
  final List<String> productImagePaths;
  final int extraProductsCount;

  const OrderModel({
    required this.id,
    required this.dateKey,
    required this.total,
    required this.status,
    required this.productImagePaths,
    this.extraProductsCount = 0,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final products = json['products'] as List? ?? [];
    final imagePaths = products
        .map((p) => p['url']?.toString() ?? '')
        .where((url) => url.isNotEmpty)
        .toList();
    final extraCount = products.length > 2 ? products.length - 2 : 0;

    return OrderModel(
      id: json['id']?.toString() ?? '',
      dateKey: json['date']?.toString() ?? '',
      total:
          (json['total_price'] as num?)?.toDouble() ??
          (json['order_price'] as num?)?.toDouble() ??
          0.0,
      status: _parseStatus(json['status']?.toString() ?? ''),
      productImagePaths: imagePaths,
      extraProductsCount: extraCount,
    );
  }

  static OrderStatus _parseStatus(String status) {
    return switch (status) {
      'pending' => OrderStatus.pendingApproval,
      'preparing' => OrderStatus.preparing,
      'on_way' => OrderStatus.onWay,
      'delivered' => OrderStatus.delivered,
      'canceled' => OrderStatus.cancelled,
      _ => OrderStatus.pendingApproval,
    };
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      dateKey: dateKey,
      total: total,
      status: status,
      productImagePaths: productImagePaths,
      extraProductsCount: extraProductsCount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    dateKey,
    total,
    status,
    productImagePaths,
    extraProductsCount,
  ];
}
