import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/core/cache/cache_keys.dart';
import 'package:thimar/core/cache/cache_constants.dart';
import 'package:thimar/core/models/user_role.dart';

class RoleService {
  final HiveCacheService _cacheService;

  RoleService(this._cacheService);

  UserRole get currentRole {
    final role = _cacheService.get<String>(
      key: CacheKeys.userRole,
      boxName: CacheConstants.userBox,
    );
    return UserRole.fromString(role);
  }

  UserRole get onboardingRole {
    final role = _cacheService.get<String>(
      key: CacheKeys.userRole,
      boxName: CacheConstants.appBox,
    );
    return UserRole.fromString(role);
  }

  Future<void> saveOnboardingRole(UserRole role) async {
    await _cacheService.save(
      key: CacheKeys.userRole,
      value: role.storageValue,
      boxName: CacheConstants.appBox,
    );
  }

  Future<void> saveUserRole(UserRole role) async {
    await _cacheService.save(
      key: CacheKeys.userRole,
      value: role.storageValue,
      boxName: CacheConstants.userBox,
    );
  }

  bool get hasOnboardingRole {
    final role = _cacheService.get<String>(
      key: CacheKeys.userRole,
      boxName: CacheConstants.appBox,
    );
    return role != null && role.isNotEmpty;
  }

  bool get isLoggedIn {
    final token = _cacheService.get<String>(
      key: CacheKeys.token,
      boxName: CacheConstants.userBox,
    );
    return token != null && token.isNotEmpty;
  }

  Future<void> clearOnboardingRole() async {
    await _cacheService.delete(
      key: CacheKeys.userRole,
      boxName: CacheConstants.appBox,
    );
  }
}
