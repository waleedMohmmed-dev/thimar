import 'package:thimar/features/addresses/domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.type,
    required super.phone,
    required super.description,
    required super.location,
    required super.lat,
    required super.lng,
    super.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as int? ?? 0,
      type: json['type'] as String? ?? 'home',
      phone: json['phone'] as String? ?? '',
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0,
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'phone': phone,
      'description': description,
      'location': location,
      'lat': lat,
      'lng': lng,
      'is_default': isDefault,
    };
  }

  AddressEntity toEntity() {
    return AddressEntity(
      id: id,
      type: type,
      phone: phone,
      description: description,
      location: location,
      lat: lat,
      lng: lng,
      isDefault: isDefault,
    );
  }
}
