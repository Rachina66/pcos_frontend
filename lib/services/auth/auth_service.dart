// ─── 1. lib/services/auth/auth_service.dart ──────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../models/api/api_response_model.dart';
import '../../models/auth/auth_data_model.dart';

class AuthService {
  // LOGIN
  static Future<ApiResponseModel<AuthDataModel>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final jsonBody = jsonDecode(response.body);
    return ApiResponseModel<AuthDataModel>.fromJson(
      jsonBody,
      (data) => AuthDataModel.fromJson(data),
    );
  }

  // REGISTER — now returns email only (no token yet)
  static Future<ApiResponseModel<String>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    final jsonBody = jsonDecode(response.body);
    return ApiResponseModel<String>.fromJson(
      jsonBody,
      (data) => data['email'] as String,
    );
  }

  // VERIFY OTP — returns user + token on success
  static Future<ApiResponseModel<AuthDataModel>> verifyEmail({
    required String email,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.verifyEmail),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );
    final jsonBody = jsonDecode(response.body);
    return ApiResponseModel<AuthDataModel>.fromJson(
      jsonBody,
      (data) => AuthDataModel.fromJson(data),
    );
  }
}
