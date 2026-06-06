import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/models/user_role.dart';
import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/driver_endpoints.dart';
import 'package:thimar/core/networking/endpoints.dart';

import 'package:thimar/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String phone,
    required String password,
    required String userType,
    required double lat,
    required double lng,
  });

  Future<UserModel?> registerDriver({
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
  });

  Future<void> verifyAccount({required String code, required String phone});

  Future<void> forgotPassword({required String phone});

  Future<void> resendCode({required String phone});

  Future<void> resetPassword({
    required String phone,
    required String code,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<UserModel> login({
    required String phone,
    required String password,
    required String userType,
    required double lat,
    required double lng,
  }) async {
    final normalizedUserType = UserRole.fromString(userType).apiValue;
    final formData = FormData.fromMap(<String, dynamic>{
      'phone': phone,
      'password': password,
      'device_token': 'test',
      'type': 'ios',
      'user_type': normalizedUserType,
      'lat': lat.toString(),
      'lng': lng.toString(),
    });

    final response = await _apiService.post(
      Endpoints.login,
      body: formData,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );
    return UserModel.fromJson(response['data']);
  }

  @override
  Future<UserModel?> registerDriver({
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
    final formDataMap = <String, dynamic>{
      'fullname': name,
      'phone': phone,
      'password': password,
      'password_confirmation': password,
      'email': email,
      'city_id': cityId,
      'identity_number': identityNumber,
      'lat': lat.toString(),
      'lng': lng.toString(),
      'location': locationDescription,
      'car_type': vehicleType,
      'model_id': modelId,
      'iban': iban,
      'bank_name': bankName,
    };

    if (driverLicensePath != null) {
      formDataMap['car_licence_image'] = await MultipartFile.fromFile(
        driverLicensePath,
        filename: 'car_licence_image.jpg',
      );
    }
    if (vehicleRegistrationPath != null) {
      formDataMap['car_form_image'] = await MultipartFile.fromFile(
        vehicleRegistrationPath,
        filename: 'car_form_image.jpg',
      );
    }
    if (vehicleInsurancePath != null) {
      formDataMap['car_insurance_image'] = await MultipartFile.fromFile(
        vehicleInsurancePath,
        filename: 'car_insurance_image.jpg',
      );
    }
    if (vehicleFrontPath != null) {
      formDataMap['car_front_image'] = await MultipartFile.fromFile(
        vehicleFrontPath,
        filename: 'car_front_image.jpg',
      );
    }
    if (vehicleRearPath != null) {
      formDataMap['car_back_image'] = await MultipartFile.fromFile(
        vehicleRearPath,
        filename: 'car_back_image.jpg',
      );
    }

    final formData = FormData.fromMap(formDataMap);
    final response = await _apiService.post(
      DriverEndpoints.register,
      body: formData,
    );
    final data = response['data'];
    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  @override
  Future<void> verifyAccount({
    required String code,
    required String phone,
  }) async {
    final formData = FormData.fromMap({
      'code': code,
      'phone': phone,
      'device_token': 'test',
      'type': 'ios',
    });

    await _apiService.post(Endpoints.verify, body: formData);
  }

  @override
  Future<void> forgotPassword({required String phone}) async {
    final formData = FormData.fromMap({'phone': phone});

    await _apiService.post(Endpoints.forgetPassword, body: formData);
  }

  @override
  Future<void> resendCode({required String phone}) async {
    final formData = FormData.fromMap({'phone': phone});

    await _apiService.post(Endpoints.resendCode, body: formData);
  }

  @override
  Future<void> resetPassword({
    required String phone,
    required String code,
    required String password,
  }) async {
    final formData = FormData.fromMap({
      'phone': phone,
      'code': code,
      'password': password,
      'password_confirmation': password,
    });

    await _apiService.post(Endpoints.resetPassword, body: formData);
  }
}
