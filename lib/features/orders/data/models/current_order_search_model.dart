import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';

class CurrentOrderSearchModel extends Equatable {
  final String id;
  final String status;
  final String date;
  final String time;
  final double orderPrice;
  final double deliveryPrice;
  final double totalPrice;
  final String clientName;
  final String clientImage;
  final String phone;
  final String location;
  final List<String> images;
  final String addressFull;

  const CurrentOrderSearchModel({
    required this.id,
    required this.status,
    required this.date,
    required this.time,
    required this.orderPrice,
    required this.deliveryPrice,
    required this.totalPrice,
    required this.clientName,
    required this.clientImage,
    required this.phone,
    required this.location,
    required this.images,
    required this.addressFull,
  });

  factory CurrentOrderSearchModel.fromJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>?;
    final addressParts = <String>[];
    if (address != null) {
      if (address['city'] != null) addressParts.add(address['city'].toString());
      if (address['country'] != null) {
        addressParts.add(address['country'].toString());
      }
    }

    final imagesList = json['images'] as List? ?? [];
    final imagePaths = imagesList
        .map((img) {
          if (img is Map<String, dynamic>) {
            return img['url']?.toString() ?? '';
          }
          return img?.toString() ?? '';
        })
        .where((url) => url.isNotEmpty)
        .toList();

    return CurrentOrderSearchModel(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      orderPrice: (json['order_price'] as num?)?.toDouble() ?? 0.0,
      deliveryPrice: (json['delivery_price'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      clientName: json['client_name']?.toString() ?? '',
      clientImage: json['client_image']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      images: imagePaths,
      addressFull: addressParts.join(', '),
    );
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      dateKey: '$date $time',
      total: totalPrice,
      status: _parseStatus(status),
      productImagePaths: images,
      extraProductsCount: 0,
      customerName: clientName,
      phoneNumber: phone,
      address: addressFull.isNotEmpty ? addressFull : location,
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
    clientImage,
    phone,
    location,
    images,
    addressFull,
  ];
}
