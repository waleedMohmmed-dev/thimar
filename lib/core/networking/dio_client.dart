import 'dart:async';
import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/networking/endpoints.dart';
import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/core/cache/cache_keys.dart';
import 'package:thimar/core/cache/cache_constants.dart';

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
      await _cacheService.delete(
        key: CacheKeys.token,
        boxName: CacheConstants.userBox,
      );
      await _cacheService.delete(
        key: CacheKeys.userId,
        boxName: CacheConstants.userBox,
      );
      await _cacheService.delete(
        key: CacheKeys.userType,
        boxName: CacheConstants.userBox,
      );
    } catch (_) {}
    _authController.add(null);
  }

  Dio get dio => _dio;
}
