import 'package:thimar/features/account/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.id,
    super.name,
    super.email,
    super.phone,
    super.profileImage,
    super.address,
    super.createdAt,
    super.role = null,
    super.vehicleType,
    super.vehicleModel,
    super.iban,
    super.bankName,
    super.driverLicenseImage,
    super.vehicleRegistrationImage,
    super.vehicleInsuranceImage,
    super.vehicleFrontImage,
    super.vehicleRearImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      name: (json['name'] as String?) ?? (json['fullname'] as String?),
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      profileImage:
          (json['profile_image'] as String?) ?? (json['image'] as String?),
      address: json['address'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      role: (json['role'] as String? ?? json['user_type'] as String? ?? 'user')
          .toLowerCase(),
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
