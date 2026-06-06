import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/networking/dio_client.dart';

class ApiService {
  final DioClient _dioClient;

  ApiService(this._dioClient);

  /// GET request
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dioClient.dio.get(
        endpoint,
        queryParameters: params,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request
  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    Options? options,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        endpoint,
        data: body,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT request
  Future<dynamic> put(String endpoint, {dynamic body}) async {
    try {
      final response = await _dioClient.dio.put(endpoint, data: body);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE request
  Future<dynamic> delete(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _dioClient.dio.delete(
        endpoint,
        data: body,
        queryParameters: params,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Convert DioException to our custom exceptions
  Exception _handleDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    // Extract message from response body safely
    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString() ?? data['error']?.toString();
      if (message != null) {
        return ServerException(message: message, statusCode: statusCode);
      }
      if (data['errors'] != null) {
        final errors = data['errors'];
        String? msg;
        if (errors is Map) {
          msg = errors.values.first?.toString();
        } else if (errors is List) {
          msg = errors.first?.toString();
        }
        if (msg != null) {
          return ServerException(message: msg, statusCode: statusCode);
        }
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'No internet connection. Please check your network.',
        );
      case DioExceptionType.badResponse:
        String msg = 'An unexpected error occurred. Please try again.';
        final body = error.response?.data;
        if (body is Map<String, dynamic>) {
          msg = body['message']?.toString() ?? body['error']?.toString() ?? msg;
          if (msg == 'An unexpected error occurred. Please try again.' &&
              body['errors'] != null) {
            final errors = body['errors'];
            if (errors is Map) {
              msg = errors.values.first?.toString() ?? msg;
            } else if (errors is List) {
              msg = errors.first?.toString() ?? msg;
            }
          }
        }
        return ServerException(message: msg, statusCode: statusCode);
      default:
        return ServerException(
          message: 'An unexpected error occurred. Please try again.',
          statusCode: statusCode,
        );
    }
  }
}
