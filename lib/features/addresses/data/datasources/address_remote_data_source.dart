import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/endpoints.dart';
import 'package:thimar/features/addresses/data/models/address_model.dart';

abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> addAddress({
    required String type,
    required String phone,
    required String description,
    required String location,
    required double lat,
    required double lng,
    required bool isDefault,
  });
  Future<AddressModel> updateAddress({
    required int id,
    required String type,
    required String phone,
    required String description,
    required String location,
    required double lat,
    required double lng,
    required bool isDefault,
  });
  Future<void> deleteAddress(int id);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final ApiService _apiService;

  AddressRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<AddressModel>> getAddresses() async {
    final response = await _apiService.get(Endpoints.clientAddresses);
    final data = response['data'];
    if (data is List) {
      return data
          .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<AddressModel> addAddress({
    required String type,
    required String phone,
    required String description,
    required String location,
    required double lat,
    required double lng,
    required bool isDefault,
  }) async {
    final body = {
      'type': type,
      'phone': phone,
      'description': description,
      'location': location,
      'lat': lat,
      'lng': lng,
      'is_default': isDefault,
    };

    final response = await _apiService.post(
      Endpoints.clientAddresses,
      body: body,
    );
    return AddressModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<AddressModel> updateAddress({
    required int id,
    required String type,
    required String phone,
    required String description,
    required String location,
    required double lat,
    required double lng,
    required bool isDefault,
  }) async {
    final body = {
      'type': type,
      'phone': phone,
      'description': description,
      'location': location,
      'lat': lat,
      'lng': lng,
      'is_default': isDefault,
    };

    final response = await _apiService.post(
      Endpoints.clientAddressDetails(id.toString()),
      body: body,
    );
    return AddressModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> deleteAddress(int id) async {
    await _apiService.delete(Endpoints.clientAddressDetails(id.toString()));
  }
}
