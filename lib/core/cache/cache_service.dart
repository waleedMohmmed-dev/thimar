import 'hive_service.dart';
import 'cache_constants.dart';

class HiveCacheService {
  final HiveService _hiveService;

  HiveCacheService(this._hiveService);

  Future<void> save<T>({
    required String key,
    required T value,
    String boxName = CacheConstants.appBox,
  }) async {
    await _hiveService.write<T>(boxName, key, value);
  }

  T? get<T>({required String key, String boxName = CacheConstants.appBox}) {
    return _hiveService.read<T>(boxName, key);
  }

  Future<void> delete({
    required String key,
    String boxName = CacheConstants.appBox,
  }) async {
    await _hiveService.delete(boxName, key);
  }

  Future<void> clear({String boxName = CacheConstants.appBox}) async {
    await _hiveService.clear(boxName);
  }

  Future<void> clearAll() async {
    await Future.wait([
      _hiveService.clear(CacheConstants.appBox),
      _hiveService.clear(CacheConstants.userBox),
      _hiveService.clear(CacheConstants.settingsBox),
    ]);
  }
}
