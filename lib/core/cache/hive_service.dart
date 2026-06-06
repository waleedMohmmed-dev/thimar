import 'package:hive_flutter/hive_flutter.dart';
import 'cache_constants.dart';

class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();
    await openBoxes();
  }

  Future<void> openBoxes() async {
    await Future.wait([
      Hive.openBox(CacheConstants.appBox),
      Hive.openBox(CacheConstants.userBox),
      Hive.openBox(CacheConstants.settingsBox),
      Hive.openBox(CacheConstants.addressesBox),
    ]);
  }

  Box getBox(String boxName) {
    return Hive.box(boxName);
  }

  Future<void> write<T>(String boxName, String key, T value) async {
    final box = getBox(boxName);
    await box.put(key, value);
  }

  T? read<T>(String boxName, String key) {
    final box = getBox(boxName);
    return box.get(key) as T?;
  }

  Future<void> delete(String boxName, String key) async {
    final box = getBox(boxName);
    await box.delete(key);
  }

  Future<void> clear(String boxName) async {
    final box = getBox(boxName);
    await box.clear();
  }

  Future<void> close() async {
    await Hive.close();
  }
}
