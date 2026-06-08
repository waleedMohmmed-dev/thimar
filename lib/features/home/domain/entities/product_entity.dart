import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? priceBeforeDiscount;
  final String imageUrl;
  final double? discount;
  final bool isFavorite;
  final String unitName;
  final String unitType;
  final int amount;
  final String code;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.priceBeforeDiscount,
    required this.imageUrl,
    this.discount,
    this.isFavorite = false,
    this.unitName = 'Kilogram',
    this.unitType = 'kilogram',
    this.amount = 0,
    this.code = '',
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    priceBeforeDiscount,
    imageUrl,
    discount,
    isFavorite,
    unitName,
    unitType,
    amount,
    code,
  ];
}
