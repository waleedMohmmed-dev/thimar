import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String phone,
    required String password,
    required double lat,
    required double lng,
  });

  Future<Either<Failure, UserEntity?>> registerDriver({
    required String name,
    required String email,
    required String phone,
    required String cityId,
    required String password,
    required String identityNumber,
    required double lat,
    required double lng,
    required String locationDescription,
    required String vehicleType,
    required String modelId,
    required String iban,
    required String bankName,
    String? driverLicensePath,
    String? vehicleRegistrationPath,
    String? vehicleInsurancePath,
    String? vehicleFrontPath,
    String? vehicleRearPath,
  });

  Future<Either<Failure, void>> verifyAccount({
    required String code,
    required String phone,
  });

  Future<Either<Failure, void>> forgotPassword({
    required String phone,
  });

  Future<Either<Failure, void>> resendCode({
    required String phone,
  });

  Future<Either<Failure, void>> resetPassword({
    required String phone,
    required String code,
    required String password,
  });
}
