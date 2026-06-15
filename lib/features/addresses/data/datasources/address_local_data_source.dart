import 'dart:convert';
import 'package:thimar/core/cache/cache_constants.dart';
import 'package:thimar/core/cache/cache_keys.dart';
import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/features/addresses/data/models/address_model.dart';

abstract class AddressLocalDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<void> addAddress(AddressModel address);
  Future<void> deleteAddress(int id);
  Future<void> updateAddress(AddressModel address);
}

class AddressLocalDataSourceImpl implements AddressLocalDataSource {
  final HiveCacheService _cacheService;

  AddressLocalDataSourceImpl(this._cacheService);

  @override
  Future<List<AddressModel>> getAddresses() async {
    final raw = _cacheService.get<String>(
      key: CacheKeys.addresses,
      boxName: CacheConstants.addressesBox,
    );
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addAddress(AddressModel address) async {
    final list = await getAddresses();
    list.add(address);
    await _saveList(list);
  }

  @override
  Future<void> deleteAddress(int id) async {
    final list = await getAddresses();
    list.removeWhere((a) => a.id == id);
    await _saveList(list);
  }

  @override
  Future<void> updateAddress(AddressModel address) async {
    final list = await getAddresses();
    final idx = list.indexWhere((a) => a.id == address.id);
    if (idx != -1) {
      list[idx] = address;
      await _saveList(list);
    }
  }

  Future<void> _saveList(List<AddressModel> list) async {
    final json = jsonEncode(list.map((a) => a.toJson()).toList());
    await _cacheService.save<String>(
      key: CacheKeys.addresses,
      value: json,
      boxName: CacheConstants.addressesBox,
    );
  }
}
