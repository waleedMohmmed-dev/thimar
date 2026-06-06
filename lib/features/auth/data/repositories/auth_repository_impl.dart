import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/core/cache/cache_keys.dart';
import 'package:thimar/core/cache/cache_constants.dart';
import 'package:thimar/core/models/user_role.dart';
import 'package:thimar/features/auth/domain/entities/user_entity.dart';
import 'package:thimar/features/auth/domain/repositories/auth_repository.dart';
import 'package:thimar/features/auth/data/datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final HiveCacheService _cacheService;

  AuthRepositoryImpl(this.remoteDataSource, this._cacheService);

  @override
  Future<Either<Failure, UserEntity>> login({
    required String phone,
    required String password,
    required double lat,
    required double lng,
  }) async {
    try {
      final userModel = await remoteDataSource.login(
        phone: phone,
        password: password,
        lat: lat,
        lng: lng,
      );
      await _saveAuthData(userModel);
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final userModel = await remoteDataSource.registerDriver(
        name: name,
        email: email,
        phone: phone,
        cityId: cityId,
        password: password,
        identityNumber: identityNumber,
        lat: lat,
        lng: lng,
        locationDescription: locationDescription,
        vehicleType: vehicleType,
        modelId: modelId,
        iban: iban,
        bankName: bankName,
        driverLicensePath: driverLicensePath,
        vehicleRegistrationPath: vehicleRegistrationPath,
        vehicleInsurancePath: vehicleInsurancePath,
        vehicleFrontPath: vehicleFrontPath,
        vehicleRearPath: vehicleRearPath,
      );
      if (userModel != null) {
        await _saveAuthData(userModel);
        await _saveDriverVehicleData(
          vehicleType: vehicleType,
          modelId: modelId,
          iban: iban,
          bankName: bankName,
          driverLicensePath: driverLicensePath,
          vehicleRegistrationPath: vehicleRegistrationPath,
          vehicleInsurancePath: vehicleInsurancePath,
          vehicleFrontPath: vehicleFrontPath,
          vehicleRearPath: vehicleRearPath,
        );
      }
      return Right(userModel?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<void> _saveAuthData(dynamic userModel) async {
    final normalizedRole = UserRole.fromString(userModel.role).storageValue;
    await Future.wait([
      _cacheService.save(
        key: CacheKeys.token,
        value: userModel.token,
        boxName: CacheConstants.userBox,
      ),
      _cacheService.save(
        key: CacheKeys.userId,
        value: userModel.id,
        boxName: CacheConstants.userBox,
      ),
      _cacheService.save(
        key: CacheKeys.userRole,
        value: normalizedRole,
        boxName: CacheConstants.userBox,
      ),
    ]);
  }

  Future<void> _saveDriverVehicleData({
    required String vehicleType,
    required String modelId,
    required String iban,
    required String bankName,
    String? driverLicensePath,
    String? vehicleRegistrationPath,
    String? vehicleInsurancePath,
    String? vehicleFrontPath,
    String? vehicleRearPath,
  }) async {
    final futures = <Future>[
      _cacheService.save(
        key: CacheKeys.vehicleType,
        value: vehicleType,
        boxName: CacheConstants.userBox,
      ),
      _cacheService.save(
        key: CacheKeys.vehicleModel,
        value: modelId,
        boxName: CacheConstants.userBox,
      ),
      _cacheService.save(
        key: CacheKeys.iban,
        value: iban,
        boxName: CacheConstants.userBox,
      ),
      _cacheService.save(
        key: CacheKeys.bankName,
        value: bankName,
        boxName: CacheConstants.userBox,
      ),
    ];

    if (driverLicensePath != null) {
      futures.add(_cacheService.save(
        key: CacheKeys.driverLicense,
        value: driverLicensePath,
        boxName: CacheConstants.userBox,
      ));
    }
    if (vehicleRegistrationPath != null) {
      futures.add(_cacheService.save(
        key: CacheKeys.vehicleRegistration,
        value: vehicleRegistrationPath,
        boxName: CacheConstants.userBox,
      ));
    }
    if (vehicleInsurancePath != null) {
      futures.add(_cacheService.save(
        key: CacheKeys.vehicleInsurance,
        value: vehicleInsurancePath,
        boxName: CacheConstants.userBox,
      ));
    }
    if (vehicleFrontPath != null) {
      futures.add(_cacheService.save(
        key: CacheKeys.vehicleFront,
        value: vehicleFrontPath,
        boxName: CacheConstants.userBox,
      ));
    }
    if (vehicleRearPath != null) {
      futures.add(_cacheService.save(
        key: CacheKeys.vehicleRear,
        value: vehicleRearPath,
        boxName: CacheConstants.userBox,
      ));
    }

    await Future.wait(futures);
  }

  @override
  Future<Either<Failure, void>> verifyAccount({
    required String code,
    required String phone,
  }) async {
    try {
      await remoteDataSource.verifyAccount(code: code, phone: phone);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({
    required String phone,
  }) async {
    try {
      await remoteDataSource.forgotPassword(phone: phone);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resendCode({
    required String phone,
  }) async {
    try {
      await remoteDataSource.resendCode(phone: phone);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String phone,
    required String code,
    required String password,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        phone: phone,
        code: code,
        password: password,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
