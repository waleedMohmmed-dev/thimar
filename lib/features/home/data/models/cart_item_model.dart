import 'package:thimar/features/home/domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.title,
    required super.image,
    required super.amount,
    required super.deliveryCost,
    required super.price,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      deliveryCost:
          (json['delivery_cost'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  CartItemEntity toEntity() {
    return CartItemEntity(
      id: id,
      title: title,
      image: image,
      amount: amount,
      deliveryCost: deliveryCost,
      price: price,
    );
  }
}
