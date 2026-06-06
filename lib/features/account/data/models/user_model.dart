import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/account/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? address,
    DateTime? createdAt,
    String? role,
    String? vehicleType,
    String? vehicleModel,
    String? iban,
    String? bankName,
    String? driverLicenseImage,
    String? vehicleRegistrationImage,
    String? vehicleInsuranceImage,
    String? vehicleFrontImage,
    String? vehicleRearImage,
  }) : super(
         id: id,
         name: name,
         email: email,
         phone: phone,
         profileImage: profileImage,
         address: address,
         createdAt: createdAt,
         role: role,
         vehicleType: vehicleType,
         vehicleModel: vehicleModel,
         iban: iban,
         bankName: bankName,
         driverLicenseImage: driverLicenseImage,
         vehicleRegistrationImage: vehicleRegistrationImage,
         vehicleInsuranceImage: vehicleInsuranceImage,
         vehicleFrontImage: vehicleFrontImage,
         vehicleRearImage: vehicleRearImage,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      profileImage: json['profile_image'] as String?,
      address: json['address'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      role: json['role'] as String? ?? 'user',
      vehicleType: json['vehicle_type'] as String?,
      vehicleModel: json['vehicle_model'] as String?,
      iban: json['iban'] as String?,
      bankName: json['bank_name'] as String?,
      driverLicenseImage: json['driver_license'] as String?,
      vehicleRegistrationImage: json['vehicle_registration'] as String?,
      vehicleInsuranceImage: json['vehicle_insurance'] as String?,
      vehicleFrontImage: json['vehicle_front'] as String?,
      vehicleRearImage: json['vehicle_rear'] as String?,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      profileImage: profileImage,
      address: address,
      createdAt: createdAt,
      role: role,
      vehicleType: vehicleType,
      vehicleModel: vehicleModel,
      iban: iban,
      bankName: bankName,
      driverLicenseImage: driverLicenseImage,
      vehicleRegistrationImage: vehicleRegistrationImage,
      vehicleInsuranceImage: vehicleInsuranceImage,
      vehicleFrontImage: vehicleFrontImage,
      vehicleRearImage: vehicleRearImage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_image': profileImage,
      'address': address,
      'created_at': createdAt?.toIso8601String(),
      'role': role,
      'vehicle_type': vehicleType,
      'vehicle_model': vehicleModel,
      'iban': iban,
      'bank_name': bankName,
      'driver_license': driverLicenseImage,
      'vehicle_registration': vehicleRegistrationImage,
      'vehicle_insurance': vehicleInsuranceImage,
      'vehicle_front': vehicleFrontImage,
      'vehicle_rear': vehicleRearImage,
    };
  }
}
