import 'package:thimar/core/imports/packages_imports.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? profileImage;
  final String? address;
  final DateTime? createdAt;
  final String? role; // 'user' or 'driver'

  bool get isDriver => role?.toLowerCase() == 'driver';

  // Vehicle data fields
  final String? identityNumber;
  final int? cityId;
  final String? vehicleType;
  final String? vehicleModel;
  final String? iban;
  final String? bankName;
  final String? driverLicenseImage;
  final String? vehicleRegistrationImage;
  final String? vehicleInsuranceImage;
  final String? vehicleFrontImage;
  final String? vehicleRearImage;

  const UserEntity({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profileImage,
    this.address,
    this.createdAt,
    this.role = 'user',
    this.identityNumber,
    this.cityId,
    this.vehicleType,
    this.vehicleModel,
    this.iban,
    this.bankName,
    this.driverLicenseImage,
    this.vehicleRegistrationImage,
    this.vehicleInsuranceImage,
    this.vehicleFrontImage,
    this.vehicleRearImage,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    profileImage,
    address,
    createdAt,
    role,
    identityNumber,
    cityId,
    vehicleType,
    vehicleModel,
    iban,
    bankName,
    driverLicenseImage,
    vehicleRegistrationImage,
    vehicleInsuranceImage,
    vehicleFrontImage,
    vehicleRearImage,
  ];
}
