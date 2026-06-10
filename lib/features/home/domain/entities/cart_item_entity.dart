import 'package:thimar/core/imports/packages_imports.dart';

class CartItemEntity extends Equatable {
  final int id;
  final String title;
  final String image;
  final int amount;
  final double deliveryCost;
  final double price;

  const CartItemEntity({
    required this.id,
    required this.title,
    required this.image,
    required this.amount,
    required this.deliveryCost,
    required this.price,
  });

  CartItemEntity copyWith({int? amount}) {
    return CartItemEntity(
      id: id,
      title: title,
      image: image,
      amount: amount ?? this.amount,
      deliveryCost: deliveryCost,
      price: price,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, image, amount, deliveryCost, price];
}
