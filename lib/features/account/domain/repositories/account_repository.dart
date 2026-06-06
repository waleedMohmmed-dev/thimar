import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/account/domain/entities/user_entity.dart';
import 'package:thimar/features/account/domain/usecases/update_driver_profile_use_case.dart';

abstract class AccountRepository {
  Future<Either<Failure, UserEntity>> getUserProfile();
  Future<Either<Failure, void>> updateDriverProfile(DriverProfileParams params);
  Future<Either<Failure, void>> saveProfileImage(String imagePath);
  Future<Either<Failure, void>> logout();
}
