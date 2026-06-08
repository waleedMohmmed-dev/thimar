import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/cache/cache_constants.dart';
import 'package:thimar/core/cache/cache_keys.dart';
import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/core/networking/endpoints.dart';
import 'package:thimar/features/account/domain/entities/user_entity.dart';
import 'package:thimar/features/account/domain/usecases/update_driver_profile_use_case.dart';
import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/driver_endpoints.dart';
import 'package:thimar/features/account/data/models/user_model.dart';

enum DriverProfileStatus { initial, loading, success, failure }

class DriverProfileState extends Equatable {
  final DriverProfileStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final String? successMessage;

  const DriverProfileState({
    this.status = DriverProfileStatus.initial,
    this.user,
    this.errorMessage,
    this.successMessage,
  });

  DriverProfileState copyWith({
    DriverProfileStatus? status,
    UserEntity? user,
    String? errorMessage,
    String? successMessage,
  }) {
    return DriverProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, successMessage];
}

class DriverProfileCubit extends Cubit<DriverProfileState> {
  final ApiService _apiService;

  DriverProfileCubit(this._apiService) : super(const DriverProfileState());

  String get _profileEndpoint {
    final userType = sl<HiveCacheService>().get<String>(
      key: CacheKeys.userType,
      boxName: CacheConstants.userBox,
    );
    return userType == 'driver' ? DriverEndpoints.profile : Endpoints.clientProfile;
  }

  Future<void> getProfile() async {
    emit(state.copyWith(status: DriverProfileStatus.loading));
    try {
      final response = await _apiService.get(_profileEndpoint);
      var user = UserModel.fromJson(response['data']).toEntity();
      final cachedImage = sl<HiveCacheService>().get<String>(
        key: CacheKeys.profileImage,
        boxName: CacheConstants.userBox,
      );
      if (cachedImage != null && cachedImage.isNotEmpty) {
        user = UserEntity(
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
          identityNumber: user.identityNumber,
          cityId: user.cityId,
        );
      }
      emit(state.copyWith(status: DriverProfileStatus.success, user: user));
    } catch (e) {
      emit(
        state.copyWith(
          status: DriverProfileStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updateProfile(DriverProfileParams params) async {
    emit(state.copyWith(status: DriverProfileStatus.loading));
    try {
      final formDataMap = <String, dynamic>{
        'fullname': params.fullname,
        'phone': params.phone,
        'identity_number': params.identityNumber,
        'iban': params.iban,
        'car_type': params.carType,
        'car_model': params.carModel,
        'city_id': params.cityId.toString(),
      };

      if (params.imagePath != null) {
        formDataMap['image'] = await MultipartFile.fromFile(
          params.imagePath!,
          filename: 'image.jpg',
        );
      }
      // ... Add other file fields here ...

      final formData = FormData.fromMap(formDataMap);
      final response = await _apiService.post(
        DriverEndpoints.profile,
        body: formData,
      );
      final user = UserModel.fromJson(response['data']).toEntity();
      emit(
        state.copyWith(
          status: DriverProfileStatus.success,
          user: user,
          successMessage: response['message'] ?? 'تم تحديث البيانات بنجاح',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DriverProfileStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updateClientProfile({
    required String fullname,
    required String phone,
    required int cityId,
    String? imagePath,
    String? password,
    String? passwordConfirmation,
  }) async {
    emit(state.copyWith(status: DriverProfileStatus.loading));
    try {
      final body = <String, dynamic>{
        'fullname': fullname,
        'phone': phone,
        'city_id': cityId.toString(),
      };
      if (password != null && password.isNotEmpty) {
        body['password'] = password;
        body['password_confirmation'] = passwordConfirmation ?? password;
      }

      final response = await _apiService.post(
        Endpoints.clientProfile,
        body: imagePath != null
            ? FormData.fromMap({
                ...body,
                'image': await MultipartFile.fromFile(
                  imagePath,
                  filename: 'image.jpg',
                ),
              })
            : body,
      );
      final user = UserModel.fromJson(response['data']).toEntity();
      emit(
        state.copyWith(
          status: DriverProfileStatus.success,
          user: user,
          successMessage: response['message'] ?? 'تم التعديل بنجاح',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DriverProfileStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _apiService.put(
        Endpoints.editPassword,
        body: {'old_password': oldPassword, 'password': newPassword},
      );
    } catch (e) {
      rethrow;
    }
  }
}
