// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/auth/user_model.dart';
import '../../models/auth/auth_response_model.dart';
import '../../models/auth/api_response_model.dart';
import '../../models/auth/register_request_model.dart';
import '../../models/auth/login_request_model.dart';

class AuthService {
  // TODO: Update this with your actual backend URL
  static const String baseUrl = 'http://localhost:3000/api';

  final http.Client _client;
  final FlutterSecureStorage _secureStorage;

  AuthService({http.Client? client, FlutterSecureStorage? secureStorage})
    : _client = client ?? http.Client(),
      _secureStorage = secureStorage ?? const FlutterSecureStorage();

  // Storage keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Register new user
  Future<ApiResponse<AuthResponse>> register(RegisterRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(jsonResponse['data']);
        await _saveAuthData(authResponse);

        return ApiResponse(
          success: true,
          message: jsonResponse['message'] ?? 'Registration successful',
          data: authResponse,
        );
      } else {
        return ApiResponse(
          success: false,
          message: jsonResponse['message'] ?? 'Registration failed',
          error: jsonResponse['error'],
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error occurred',
        error: e.toString(),
      );
    }
  }

  // Login existing user
  Future<ApiResponse<AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(jsonResponse['data']);
        await _saveAuthData(authResponse);

        return ApiResponse(
          success: true,
          message: jsonResponse['message'] ?? 'Login successful',
          data: authResponse,
        );
      } else {
        return ApiResponse(
          success: false,
          message: jsonResponse['message'] ?? 'Login failed',
          error: jsonResponse['error'],
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error occurred',
        error: e.toString(),
      );
    }
  }

  // Get current user profile
  Future<ApiResponse<User>> getProfile() async {
    try {
      final token = await getToken();

      if (token == null) {
        return ApiResponse(
          success: false,
          message: 'No authentication token found',
        );
      }

      final response = await _client.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final user = User.fromJson(jsonResponse['data']);
        await _saveUser(user);

        return ApiResponse(
          success: true,
          message: jsonResponse['message'] ?? 'Profile fetched successfully',
          data: user,
        );
      } else {
        return ApiResponse(
          success: false,
          message: jsonResponse['message'] ?? 'Failed to fetch profile',
          error: jsonResponse['error'],
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error occurred',
        error: e.toString(),
      );
    }
  }

  // Save authentication data to secure storage
  Future<void> _saveAuthData(AuthResponse authResponse) async {
    await _secureStorage.write(key: _tokenKey, value: authResponse.token);
    await _secureStorage.write(
      key: _userKey,
      value: jsonEncode(authResponse.user.toJson()),
    );
  }

  // Save user data to secure storage
  Future<void> _saveUser(User user) async {
    await _secureStorage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }

  // Get stored token from secure storage
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  // Get stored user from secure storage
  Future<User?> getStoredUser() async {
    final userJson = await _secureStorage.read(key: _userKey);

    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Logout user (clear secure storage)
  Future<void> logout() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _userKey);
  }

  // Clear all auth data from secure storage
  Future<void> clearAuthData() async {
    await _secureStorage.deleteAll();
  }

  // Optional: Read all stored data (for debugging)
  Future<Map<String, String>> readAllSecureData() async {
    return await _secureStorage.readAll();
  }
}
