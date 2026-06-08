import 'package:thimar/features/home/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    super.priceBeforeDiscount,
    required super.imageUrl,
    super.discount,
    super.isFavorite = false,
    super.unitName = 'Kilogram',
    super.unitType = 'kilogram',
    super.amount = 0,
    super.code = '',
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final unit = json['unit'] as Map<String, dynamic>?;

    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['title']?.toString() ?? json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      priceBeforeDiscount: (json['price_before_discount'] as num?)?.toDouble(),
      imageUrl:
          json['main_image']?.toString() ?? json['image']?.toString() ?? '',
      discount: (json['discount'] as num?)?.toDouble(),
      isFavorite: json['is_favorite'] == true,
      unitName: unit?['name']?.toString() ?? 'Kilogram',
      unitType: unit?['type']?.toString() ?? 'kilogram',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      code: json['code']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'description': description,
      'price': price,
      'price_before_discount': priceBeforeDiscount,
      'main_image': imageUrl,
      'discount': discount,
      'is_favorite': isFavorite,
      'amount': amount,
      'code': code,
      'unit': {'name': unitName, 'type': unitType},
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      priceBeforeDiscount: priceBeforeDiscount,
      imageUrl: imageUrl,
      discount: discount,
      isFavorite: isFavorite,
      unitName: unitName,
      unitType: unitType,
      amount: amount,
      code: code,
    );
  }
}
