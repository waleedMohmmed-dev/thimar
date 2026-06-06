import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';

class OrderDetailsModel extends Equatable {
  final String id;
  final String status;
  final String date;
  final String time;
  final double orderPrice;
  final double deliveryPrice;
  final double totalPrice;
  final String clientName;
  final String clientPhone;
  final String clientImage;
  final String address;
  final String? notes;
  final String? paymentMethod;
  final List<String> productImages;

  const OrderDetailsModel({
    required this.id,
    required this.status,
    required this.date,
    required this.time,
    required this.orderPrice,
    required this.deliveryPrice,
    required this.totalPrice,
    required this.clientName,
    required this.clientPhone,
    required this.clientImage,
    required this.address,
    this.notes,
    this.paymentMethod,
    this.productImages = const [],
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    final products = json['products'] as List? ?? [];
    final imagePaths = products
        .map((p) => p['url']?.toString() ?? p['image']?.toString() ?? '')
        .where((url) => url.isNotEmpty)
        .toList();

    return OrderDetailsModel(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      orderPrice: (json['order_price'] as num?)?.toDouble() ?? 0.0,
      deliveryPrice: (json['delivery_price'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      clientName: json['client_name']?.toString() ?? '',
      clientPhone: json['phone']?.toString() ?? '',
      clientImage: json['client_image']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      notes: json['notes']?.toString(),
      paymentMethod: json['payment_method']?.toString(),
      productImages: imagePaths,
    );
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      dateKey: '$date $time',
      total: totalPrice,
      status: _parseStatus(status),
      productImagePaths: productImages,
      extraProductsCount: 0,
      customerName: clientName,
      phoneNumber: clientPhone,
      address: address,
      notes: notes,
      paymentMethod: paymentMethod,
      productsTotal: orderPrice.toStringAsFixed(0),
      deliveryPrice: deliveryPrice.toStringAsFixed(0),
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

  @override
  List<Object?> get props => [
        id,
        status,
        date,
        time,
        orderPrice,
        deliveryPrice,
        totalPrice,
        clientName,
        clientPhone,
        clientImage,
        address,
        notes,
        paymentMethod,
        productImages,
      ];
}
