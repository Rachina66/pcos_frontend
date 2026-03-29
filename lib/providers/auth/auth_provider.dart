import 'package:flutter/material.dart';

import '../../models/auth/auth_data_model.dart';
import '../../models/user/user_model.dart';
import '../../services/auth/auth_service.dart';
import '../../core/storage/secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  // =====================
  // PRIVATE STATE
  // =====================
  UserModel? _user;
  String? _token;
  bool _isLoading = false;

  // =====================
  // GETTERS
  // =====================
  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;

  bool get isAuthenticated => _token != null;

  bool get isAdmin => _user?.role == 'ADMIN';

  // =====================
  // LOGIN
  // =====================
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      final response = await AuthService.login(
        email: email,
        password: password,
      );

      if (!response.success || response.data == null) {
        return response.message;
      }

      _setAuthData(response.data!);
      return null; // success
    } catch (e) {
      return 'Something went wrong. Please try again.';
    } finally {
      _setLoading(false);
    }
  }

  // =====================
  // REGISTER
  // =====================
  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      final response = await AuthService.register(
        name: name,
        email: email,
        password: password,
      );

      if (!response.success || response.data == null) {
        return response.message;
      }

      _setAuthData(response.data!);
      return null; // success
    } catch (e) {
      return 'Registration failed. Please try again.';
    } finally {
      _setLoading(false);
    }
  }

  // =====================
  // LOGOUT
  // =====================
  Future<void> logout() async {
    _user = null;
    _token = null;
    await SecureStorage.deleteToken();
    notifyListeners();
  }

  // =====================
  // AUTO LOGIN (APP START)
  // =====================
  Future<void> tryAutoLogin() async {
    final storedToken = await SecureStorage.getToken();

    if (storedToken == null) return;

    _token = storedToken;
    notifyListeners();
  }

  // =====================
  // PRIVATE HELPERS
  // =====================
  void _setAuthData(AuthDataModel authData) async {
    _user = authData.user;
    _token = authData.token;

    await SecureStorage.saveToken(_token!);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
