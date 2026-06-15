import 'package:thimar/core/imports/packages_imports.dart';

class AddressEntity extends Equatable {
  final int id;
  final String type;
  final String phone;
  final String description;
  final String location;
  final double lat;
  final double lng;
  final bool isDefault;

  const AddressEntity({
    required this.id,
    required this.type,
    required this.phone,
    required this.description,
    required this.location,
    required this.lat,
    required this.lng,
    this.isDefault = false,
  });

  AddressEntity copyWith({
    int? id,
    String? type,
    String? phone,
    String? description,
    String? location,
    double? lat,
    double? lng,
    bool? isDefault,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      location: location ?? this.location,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  String get displayName => type == 'home' ? 'المنزل' : 'العمل';

  @override
  List<Object?> get props => [
        id,
        type,
        phone,
        description,
        location,
        lat,
        lng,
        isDefault,
      ];
}
