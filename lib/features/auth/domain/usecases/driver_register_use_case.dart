import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/auth/domain/entities/user_entity.dart';
import 'package:thimar/features/auth/domain/repositories/auth_repository.dart';

class DriverRegisterUseCase
    implements UseCase<UserEntity?, DriverRegisterParams> {
  final AuthRepository repository;

  DriverRegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity?>> call(DriverRegisterParams params) async {
    return repository.registerDriver(
      name: params.name,
      email: params.email,
      phone: params.phone,
      cityId: params.cityId,
      password: params.password,
      identityNumber: params.identityNumber,
      lat: params.lat,
      lng: params.lng,
      locationDescription: params.locationDescription,
      vehicleType: params.vehicleType,
      modelId: params.modelId,
      iban: params.iban,
      bankName: params.bankName,
      driverLicensePath: params.driverLicensePath,
      vehicleRegistrationPath: params.vehicleRegistrationPath,
      vehicleInsurancePath: params.vehicleInsurancePath,
      vehicleFrontPath: params.vehicleFrontPath,
      vehicleRearPath: params.vehicleRearPath,
    );
  }
}

class DriverRegisterParams extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String cityId;
  final String password;
  final String identityNumber;
  final double lat;
  final double lng;
  final String locationDescription;
  final String vehicleType;
  final String modelId;
  final String iban;
  final String bankName;
  final String? driverLicensePath;
  final String? vehicleRegistrationPath;
  final String? vehicleInsurancePath;
  final String? vehicleFrontPath;
  final String? vehicleRearPath;

  const DriverRegisterParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.cityId,
    required this.password,
    required this.identityNumber,
    required this.lat,
    required this.lng,
    required this.locationDescription,
    required this.vehicleType,
    required this.modelId,
    required this.iban,
    required this.bankName,
    this.driverLicensePath,
    this.vehicleRegistrationPath,
    this.vehicleInsurancePath,
    this.vehicleFrontPath,
    this.vehicleRearPath,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    cityId,
    password,
    identityNumber,
    lat,
    lng,
    locationDescription,
    vehicleType,
    modelId,
    iban,
    bankName,
    driverLicensePath,
    vehicleRegistrationPath,
    vehicleInsurancePath,
    vehicleFrontPath,
    vehicleRearPath,
  ];
}
