import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/core/cache/cache_keys.dart';
import 'package:thimar/core/cache/cache_constants.dart';
import 'package:thimar/core/models/user_role.dart';
import 'package:thimar/features/account/data/models/user_model.dart';

abstract class AccountDataSource {
  Future<UserModel> getUserProfile();
  Future<void> updateUserProfile(UserModel user);
  Future<void> logout();
  Future<void> saveProfileImage(String imagePath);
  Future<String?> getProfileImage();
}

class AccountDataSourceImpl implements AccountDataSource {
  final HiveCacheService _cacheService;

  AccountDataSourceImpl(this._cacheService);

  @override
  Future<UserModel> getUserProfile() async {
    final imagePath = await getProfileImage();
    final role = UserRole.fromString(
      _cacheService.get<String>(
        key: CacheKeys.userType,
        boxName: CacheConstants.userBox,
      ),
    );

    return UserModel(
      id: '1',
      name: 'مستخدم',
      email: 'user@example.com',
      phone: '+966555555555',
      profileImage: imagePath,
      address: 'الرياض',
      createdAt: DateTime.now(),
      role: role.storageValue,
      vehicleType: _cacheService.get<String>(
        key: CacheKeys.vehicleType,
        boxName: CacheConstants.userBox,
      ),
      vehicleModel: _cacheService.get<String>(
        key: CacheKeys.vehicleModel,
        boxName: CacheConstants.userBox,
      ),
      iban: _cacheService.get<String>(
        key: CacheKeys.iban,
        boxName: CacheConstants.userBox,
      ),
      bankName: _cacheService.get<String>(
        key: CacheKeys.bankName,
        boxName: CacheConstants.userBox,
      ),
      driverLicenseImage: _cacheService.get<String>(
        key: CacheKeys.driverLicense,
        boxName: CacheConstants.userBox,
      ),
      vehicleRegistrationImage: _cacheService.get<String>(
        key: CacheKeys.vehicleRegistration,
        boxName: CacheConstants.userBox,
      ),
      vehicleInsuranceImage: _cacheService.get<String>(
        key: CacheKeys.vehicleInsurance,
        boxName: CacheConstants.userBox,
      ),
      vehicleFrontImage: _cacheService.get<String>(
        key: CacheKeys.vehicleFront,
        boxName: CacheConstants.userBox,
      ),
      vehicleRearImage: _cacheService.get<String>(
        key: CacheKeys.vehicleRear,
        boxName: CacheConstants.userBox,
      ),
    );
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    if (user.profileImage != null) {
      await saveProfileImage(user.profileImage!);
    }
    // Save vehicle data if present
    final userRole = UserRole.fromString(user.role);
    await _cacheService.save(
      key: CacheKeys.userType,
      value: userRole.storageValue,
      boxName: CacheConstants.userBox,
    );

    if (userRole.isDriver) {
      if (user.vehicleType != null) {
        await _cacheService.save(
          key: CacheKeys.vehicleType,
          value: user.vehicleType!,
          boxName: CacheConstants.userBox,
        );
      }
      if (user.vehicleModel != null) {
        await _cacheService.save(
          key: CacheKeys.vehicleModel,
          value: user.vehicleModel!,
          boxName: CacheConstants.userBox,
        );
      }
      if (user.iban != null) {
        await _cacheService.save(
          key: CacheKeys.iban,
          value: user.iban!,
          boxName: CacheConstants.userBox,
        );
      }
      if (user.bankName != null) {
        await _cacheService.save(
          key: CacheKeys.bankName,
          value: user.bankName!,
          boxName: CacheConstants.userBox,
        );
      }
      if (user.driverLicenseImage != null) {
        await _cacheService.save(
          key: CacheKeys.driverLicense,
          value: user.driverLicenseImage!,
          boxName: CacheConstants.userBox,
        );
      }
      if (user.vehicleRegistrationImage != null) {
        await _cacheService.save(
          key: CacheKeys.vehicleRegistration,
          value: user.vehicleRegistrationImage!,
          boxName: CacheConstants.userBox,
        );
      }
      if (user.vehicleInsuranceImage != null) {
        await _cacheService.save(
          key: CacheKeys.vehicleInsurance,
          value: user.vehicleInsuranceImage!,
          boxName: CacheConstants.userBox,
        );
      }
      if (user.vehicleFrontImage != null) {
        await _cacheService.save(
          key: CacheKeys.vehicleFront,
          value: user.vehicleFrontImage!,
          boxName: CacheConstants.userBox,
        );
      }
      if (user.vehicleRearImage != null) {
        await _cacheService.save(
          key: CacheKeys.vehicleRear,
          value: user.vehicleRearImage!,
          boxName: CacheConstants.userBox,
        );
      }
    }
  }

  @override
  Future<void> saveProfileImage(String imagePath) async {
    await _cacheService.save(
      key: CacheKeys.profileImage,
      value: imagePath,
      boxName: CacheConstants.userBox,
    );
  }

  @override
  Future<String?> getProfileImage() async {
    return _cacheService.get<String>(
      key: CacheKeys.profileImage,
      boxName: CacheConstants.userBox,
    );
  }

  @override
  Future<void> logout() async {
    await _cacheService.clear(boxName: CacheConstants.userBox);
  }
}
