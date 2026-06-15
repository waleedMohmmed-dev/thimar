import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';

class OrderModel extends Equatable {
  final String id;
  final String dateKey;
  final double total;
  final OrderStatus status;
  final List<String> productImagePaths;
  final List<String> productNames;
  final int extraProductsCount;
  final String? productsTotal;
  final String? deliveryPrice;
  final String? discount;
  final String? address;
  final String? notes;
  final String? deliveryDate;
  final String? deliveryTime;
  final String? paymentMethod;
  final String? customerName;
  final String? phoneNumber;
  final String? clientImage;

  const OrderModel({
    required this.id,
    required this.dateKey,
    required this.total,
    required this.status,
    required this.productImagePaths,
    this.productNames = const [],
    this.extraProductsCount = 0,
    this.productsTotal,
    this.deliveryPrice,
    this.discount,
    this.address,
    this.notes,
    this.deliveryDate,
    this.deliveryTime,
    this.paymentMethod,
    this.customerName,
    this.phoneNumber,
    this.clientImage,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final products = json['products'] as List? ?? [];
    final imagePaths = products
        .map((p) => p['url']?.toString() ?? '')
        .where((url) => url.isNotEmpty)
        .toList();
    final names = products
        .map((p) => p['name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
    final extraCount = products.length > 2 ? products.length - 2 : 0;

    final user = json['user'] as Map<String, dynamic>?;

    return OrderModel(
      id: json['id']?.toString() ?? '',
      dateKey: json['date']?.toString() ?? '',
      total:
          (json['total_price'] as num?)?.toDouble() ??
          (json['order_price'] as num?)?.toDouble() ??
          0.0,
      status: _parseStatus(json['status']?.toString() ?? ''),
      productImagePaths: imagePaths,
      productNames: names,
      extraProductsCount: extraCount,
      productsTotal: json['products_total']?.toString(),
      deliveryPrice: json['delivery_price']?.toString(),
      discount: json['discount']?.toString(),
      address: json['address']?.toString(),
      notes: json['notes']?.toString(),
      deliveryDate: json['delivery_date']?.toString(),
      deliveryTime: json['delivery_time']?.toString(),
      paymentMethod: json['payment_type']?.toString(),
      customerName: user?['name']?.toString(),
      phoneNumber: user?['phone']?.toString(),
      clientImage: user?['image_url']?.toString(),
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
      productNames: productNames,
      extraProductsCount: extraProductsCount,
      productsTotal: productsTotal,
      deliveryPrice: deliveryPrice,
      discount: discount,
      address: address,
      notes: notes,
      deliveryDate: deliveryDate,
      deliveryTime: deliveryTime,
      paymentMethod: paymentMethod,
      customerName: customerName,
      phoneNumber: phoneNumber,
      clientImage: clientImage,
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
    productsTotal,
    deliveryPrice,
    discount,
    address,
    notes,
    deliveryDate,
    deliveryTime,
    paymentMethod,
    customerName,
    phoneNumber,
    clientImage,
  ];
}
