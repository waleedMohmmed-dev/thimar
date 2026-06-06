import 'dart:async';
import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/networking/endpoints.dart';
import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/core/cache/cache_keys.dart';
import 'package:thimar/core/cache/cache_constants.dart';

import 'package:thimar/core/models/user_role.dart';
import 'package:thimar/core/services/screen_tracker_service.dart';
import 'dart:developer' as dev;

class DioClient {
  final Dio _dio;
  final HiveCacheService _cacheService;

  static final StreamController<void> _authController =
      StreamController<void>.broadcast();

  static Stream<void> get onUnauthorized => _authController.stream;

  DioClient(this._dio, this._cacheService) {
    _dio.options
      ..baseUrl = Endpoints.baseUrl
      ..headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30)
      ..sendTimeout = const Duration(seconds: 30);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final roleValue = _cacheService.get<String>(
            key: CacheKeys.userRole,
            boxName: CacheConstants.userBox,
          );
          final role = UserRole.fromString(roleValue);

          // MANDATORY LOGGING FOR DRIVER MODE
          dev.log(
            '----------------------------------------\n'
            'ROLE: ${role.name.toUpperCase()}\n'
            'SCREEN: ${ScreenTrackerService.currentScreen}\n'
            'ENDPOINT: ${options.path}\n'
            '----------------------------------------',
            name: 'API_LOG',
          );

          final token = _cacheService.get<String>(
            key: CacheKeys.token,
            boxName: CacheConstants.userBox,
          );
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _handleUnauthorized();
          }
          return handler.next(error);
        },
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<void> _handleUnauthorized() async {
    try {
      await _cacheService.delete(key: CacheKeys.token, boxName: CacheConstants.userBox);
      await _cacheService.delete(key: CacheKeys.userId, boxName: CacheConstants.userBox);
      await _cacheService.delete(key: CacheKeys.userRole, boxName: CacheConstants.userBox);
    } catch (_) {}
    _authController.add(null);
  }

  Dio get dio => _dio;
}
