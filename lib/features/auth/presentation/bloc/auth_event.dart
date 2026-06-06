import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String phone;
  final String password;
  final double lat;
  final double lng;

  const LoginSubmitted({
    required this.phone,
    required this.password,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [phone, password, lat, lng];
}

class RegisterSubmitted extends AuthEvent {
  final String name;
  final String phone;
  final String gender;
  final double lat;
  final double lng;
  final String password;

  const RegisterSubmitted({
    required this.name,
    required this.phone,
    required this.gender,
    required this.lat,
    required this.lng,
    required this.password,
  });

  @override
  List<Object?> get props => [name, phone, gender, lat, lng, password];
}

class DriverRegisterSubmitted extends AuthEvent {
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

  const DriverRegisterSubmitted({
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

class VerifyOtpSubmitted extends AuthEvent {
  final String code;
  final String phone;

  const VerifyOtpSubmitted({
    required this.code,
    required this.phone,
  });

  @override
  List<Object?> get props => [code, phone];
}

class ForgotPasswordSubmitted extends AuthEvent {
  final String phone;

  const ForgotPasswordSubmitted({required this.phone});

  @override
  List<Object?> get props => [phone];
}

class ResendCodeSubmitted extends AuthEvent {
  final String phone;

  const ResendCodeSubmitted({required this.phone});

  @override
  List<Object?> get props => [phone];
}

class ResetPasswordSubmitted extends AuthEvent {
  final String phone;
  final String code;
  final String password;

  const ResetPasswordSubmitted({
    required this.phone,
    required this.code,
    required this.password,
  });

  @override
  List<Object?> get props => [phone, code, password];
}
