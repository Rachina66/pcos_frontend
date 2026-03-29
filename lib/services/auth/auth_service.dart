import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../../models/api/api_response_model.dart';
import '../../models/auth/auth_data_model.dart';

class AuthService {
  //handle login services
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

  //handle register services
  static Future<ApiResponseModel<AuthDataModel>> register({
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

    return ApiResponseModel<AuthDataModel>.fromJson(
      jsonBody,
      (data) => AuthDataModel.fromJson(data),
    );
  }
}
