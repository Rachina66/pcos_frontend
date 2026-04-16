// lib/services/profile/profile_service.dart

import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../models/user/user_model.dart';

class ProfileService {
  final Dio _dio = ApiClient().dio;

  // Update name
  Future<UserModel> updateName(String name) async {
    try {
      final response = await _dio.put('/profile/name', data: {'name': name});
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // Change password (requires current password)
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.put(
        '/profile/change-password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  //  Forgot password — send OTP
  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post('/profile/forgot-password', data: {'email': email});
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // Verify OTP
  Future<void> verifyOtp({required String email, required String otp}) async {
    try {
      await _dio.post(
        '/profile/verify-otp',
        data: {'email': email, 'otp': otp},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  //  Reset password after OTP
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await _dio.post(
        '/profile/reset-password',
        data: {'email': email, 'newPassword': newPassword},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
