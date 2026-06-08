import 'package:thimar/core/cache/cache_constants.dart';
import 'package:thimar/core/cache/cache_keys.dart';
import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/driver_endpoints.dart';
import 'package:thimar/core/networking/endpoints.dart';
import 'package:thimar/features/account/data/models/user_model.dart';
import 'package:thimar/features/account/domain/usecases/update_driver_profile_use_case.dart';

abstract class AccountRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<void> updateDriverProfile(DriverProfileParams params);
  Future<void> logout();
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final ApiService _apiService;
  final HiveCacheService _cacheService;

  AccountRemoteDataSourceImpl(this._apiService, this._cacheService);

  String get _profileEndpoint {
    final userType = _cacheService.get<String>(
      key: CacheKeys.userType,
      boxName: CacheConstants.userBox,
    );
    if (userType == 'driver') {
      return DriverEndpoints.profile;
    }
    return Endpoints.clientProfile;
  }

  @override
  Future<UserModel> getUserProfile() async {
    final response = await _apiService.get(_profileEndpoint);
    return UserModel.fromJson(response['data']);
  }

  @override
  Future<void> updateDriverProfile(DriverProfileParams params) async {
    final formDataMap = <String, dynamic>{
      'fullname': params.fullname,
      'phone': params.phone,
      'identity_number': params.identityNumber,
      'iban': params.iban,
      'car_type': params.carType,
      'car_model': params.carModel,
      'city_id': params.cityId.toString(),
    };

    if (params.password.isNotEmpty) {
      formDataMap['password'] = params.password;
    }

    if (params.imagePath != null) {
      formDataMap['image'] = await MultipartFile.fromFile(
        params.imagePath!,
        filename: 'image.jpg',
      );
    }
    if (params.carLicenceImagePath != null) {
      formDataMap['car_licence_image'] = await MultipartFile.fromFile(
        params.carLicenceImagePath!,
        filename: 'car_licence_image.jpg',
      );
    }
    if (params.carFormImagePath != null) {
      formDataMap['car_form_image'] = await MultipartFile.fromFile(
        params.carFormImagePath!,
        filename: 'car_form_image.jpg',
      );
    }
    if (params.carInsuranceImagePath != null) {
      formDataMap['car_insurance_image'] = await MultipartFile.fromFile(
        params.carInsuranceImagePath!,
        filename: 'car_insurance_image.jpg',
      );
    }
    if (params.carFrontImagePath != null) {
      formDataMap['car_front_image'] = await MultipartFile.fromFile(
        params.carFrontImagePath!,
        filename: 'car_front_image.jpg',
      );
    }
    if (params.carBackImagePath != null) {
      formDataMap['car_back_image'] = await MultipartFile.fromFile(
        params.carBackImagePath!,
        filename: 'car_back_image.jpg',
      );
    }

    final formData = FormData.fromMap(formDataMap);

    await _apiService.post(_profileEndpoint, body: formData);
  }

  @override
  Future<void> logout() async {
    await _apiService.post(
      Endpoints.logout,
      body: {'device_token': 'test', 'type': 'ios'},
    );
  }
}
