import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return "Connection timeout with API server";
        case DioExceptionType.sendTimeout:
          return "Send timeot uin connection with API server";
        case DioExceptionType.receiveTimeout:
          return "Receive timeout in connection with API server";
        case DioExceptionType.badCertificate:
          return "Bad certificate with API server";
        case DioExceptionType.badResponse:
          return _handleBadResponse(error.response);
        case DioExceptionType.cancel:
          return "Request to API server was cancelled";
        case DioExceptionType.connectionError:
          return "Connection to API server failed due to internet connection";
        case DioExceptionType.unknown:
          return "Connection to API server failed due to unknown error";
      }
    } else {
      return "Unexpected error occurred";
    }
  }

  static String _handleBadResponse(Response? response) {
    if (response == null) return "Unknown error occurred";

    final statusCode = response.statusCode;
    final message = response.data is Map
        ? response.data['message']
        : response.statusMessage;

    switch (statusCode) {
      case 400:
        return message ?? "Bad request";
      case 401:
        return message ?? "Unauthorized";
      case 403:
        return message ?? "Forbidden";
      case 404:
        return message ?? "Not found";
      case 409:
        return message ?? "Conflict";
      case 500:
        return "Internal server error";
      case 503:
        return "Service unavailable";
      default:
        return message ?? "Received invalid status code: $statusCode";
    }
  }
}
