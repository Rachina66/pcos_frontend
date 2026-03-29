import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errors;

  ApiException({required this.message, this.statusCode, this.errors});

  @override
  String toString() => message;

  static ApiException fromDioException(DioException e) {
    if (e.response == null) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiException(
          message: 'Connection timed out. Please check your internet.',
        );
      }
      if (e.type == DioExceptionType.connectionError) {
        return ApiException(message: 'No internet connection.');
      }
      return ApiException(message: 'Something went wrong. Please try again.');
    }

    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    String message = 'Something went wrong.';
    dynamic errors;

    if (data is Map<String, dynamic>) {
      message = data['message'] ?? message;
      errors = data['errors'];
    }

    if (statusCode == 401) {
      return ApiException(
        message: 'Session expired. Please login again.',
        statusCode: statusCode,
      );
    }

    if (statusCode == 403) {
      return ApiException(
        message: message.isNotEmpty ? message : 'You are not authorized.',
        statusCode: statusCode,
      );
    }

    if (statusCode == 404) {
      return ApiException(
        message: message.isNotEmpty ? message : 'Resource not found.',
        statusCode: statusCode,
      );
    }

    if (statusCode == 500) {
      return ApiException(
        message: 'Server error. Please try again later.',
        statusCode: statusCode,
      );
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      errors: errors,
    );
  }
}
