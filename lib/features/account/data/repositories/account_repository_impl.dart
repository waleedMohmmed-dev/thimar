import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/account/data/datasources/account_datasource.dart';
import 'package:thimar/features/account/data/datasources/account_remote_data_source.dart';
import 'package:thimar/features/account/domain/entities/user_entity.dart';
import 'package:thimar/features/account/domain/repositories/account_repository.dart';
import 'package:thimar/features/account/domain/usecases/update_driver_profile_use_case.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountDataSource dataSource;
  final AccountRemoteDataSource remoteDataSource;

  AccountRepositoryImpl({
    required this.dataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final user = await remoteDataSource.getUserProfile();
      final cachedImage = await dataSource.getProfileImage();
      if (cachedImage != null && cachedImage.isNotEmpty) {
        return Right(
          UserEntity(
            id: user.id,
            name: user.name,
            email: user.email,
            phone: user.phone,
            profileImage: cachedImage,
            address: user.address,
            createdAt: user.createdAt,
            role: user.role,
            vehicleType: user.vehicleType,
            vehicleModel: user.vehicleModel,
            iban: user.iban,
            bankName: user.bankName,
            driverLicenseImage: user.driverLicenseImage,
            vehicleRegistrationImage: user.vehicleRegistrationImage,
            vehicleInsuranceImage: user.vehicleInsuranceImage,
            vehicleFrontImage: user.vehicleFrontImage,
            vehicleRearImage: user.vehicleRearImage,
          ),
        );
      }
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateDriverProfile(
    DriverProfileParams params,
  ) async {
    try {
      await remoteDataSource.updateDriverProfile(params);
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
  Future<Either<Failure, void>> saveProfileImage(String imagePath) async {
    try {
      await dataSource.saveProfileImage(imagePath);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (_) {}
    try {
      await dataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
