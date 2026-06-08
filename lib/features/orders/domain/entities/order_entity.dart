import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

enum OrderStatus { pendingApproval, preparing, onWay, delivered, cancelled }

class OrderEntity extends Equatable {
  final String id;
  final String dateKey;
  final double total;
  final OrderStatus status;
  final List<String> productImagePaths;
  final List<String> productNames;
  final int extraProductsCount;

  // Form data (used when completing an order)
  final String? customerName;
  final String? phoneNumber;
  final String? address;
  final String? deliveryDate;
  final String? deliveryTime;
  final String? clientImage;
  final String? notes;
  final String? paymentMethod;
  final String? productsTotal;
  final String? deliveryPrice;
  final String? discount;

  const OrderEntity({
    required this.id,
    required this.dateKey,
    required this.total,
    required this.status,
    required this.productImagePaths,
    this.extraProductsCount = 0,
    this.productNames = const [],
    this.customerName,
    this.phoneNumber,
    this.clientImage,
    this.address,
    this.deliveryDate,
    this.deliveryTime,
    this.notes,
    this.paymentMethod,
    this.productsTotal,
    this.deliveryPrice,
    this.discount,
  });

  OrderEntity copyWith({
    String? id,
    String? dateKey,
    double? total,
    OrderStatus? status,
    List<String>? productImagePaths,
    List<String>? productNames,
    int? extraProductsCount,
    String? customerName,
    String? phoneNumber,
    String? clientImage,
    String? address,
    String? deliveryDate,
    String? deliveryTime,
    String? notes,
    String? paymentMethod,
    String? productsTotal,
    String? deliveryPrice,
    String? discount,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      dateKey: dateKey ?? this.dateKey,
      total: total ?? this.total,
      status: status ?? this.status,
      productImagePaths: productImagePaths ?? this.productImagePaths,
      productNames: productNames ?? this.productNames,
      extraProductsCount: extraProductsCount ?? this.extraProductsCount,
      customerName: customerName ?? this.customerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      clientImage: clientImage ?? this.clientImage,
      address: address ?? this.address,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      notes: notes ?? this.notes,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      productsTotal: productsTotal ?? this.productsTotal,
      deliveryPrice: deliveryPrice ?? this.deliveryPrice,
      discount: discount ?? this.discount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    dateKey,
    total,
    status,
    productImagePaths,
    productNames,
    extraProductsCount,
    customerName,
    phoneNumber,
    clientImage,
    address,
    deliveryDate,
    deliveryTime,
    notes,
    paymentMethod,
    productsTotal,
    deliveryPrice,
    discount,
  ];
}
