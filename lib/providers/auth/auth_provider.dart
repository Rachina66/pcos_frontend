import 'package:flutter/material.dart';
import '../../models/auth/auth_data_model.dart';
import '../../models/user/user_model.dart';
import '../../services/auth/auth_service.dart';
import '../../core/storage/secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  String? _token;
  bool _isLoading = false;
  String? _pendingEmail; //email waiting for OTP verification

  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get pendingEmail => _pendingEmail;
  bool get isAuthenticated => _token != null;
  bool get isAdmin => _user?.role == 'ADMIN';

  //Login
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
      if (!response.success || response.data == null) return response.message;
      _setAuthData(response.data!);
      return null;
    } catch (e) {
      return 'Something went wrong. Please try again.';
    } finally {
      _setLoading(false);
    }
  }

  //For register send OTP
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
      if (!response.success) return response.message;
      _pendingEmail = email; //store for OTP screen
      notifyListeners();
      return null; //success,navigate to OTP screen
    } catch (e) {
      return 'Registration failed. Please try again.';
    } finally {
      _setLoading(false);
    }
  }

  //Verify OTP which completes login
  Future<String?> verifyEmail({required String otp}) async {
    if (_pendingEmail == null) return 'No email found. Please register again.';
    _setLoading(true);
    try {
      final response = await AuthService.verifyEmail(
        email: _pendingEmail!,
        otp: otp,
      );
      if (!response.success) return response.message;
      _pendingEmail = null;
      _setAuthData(response.data!);
      return null; // success → navigate to home
    } catch (e) {
      return 'Verification failed. Please try again.';
    } finally {
      _setLoading(false);
    }
  }

  //Logout
  Future<void> logout() async {
    _user = null;
    _token = null;
    await SecureStorage.deleteToken();
    notifyListeners();
  }

  // ── AUTO LOGIN ──
  Future<void> tryAutoLogin() async {
    final storedToken = await SecureStorage.getToken();
    if (storedToken == null) return;
    _token = storedToken;
    notifyListeners();
  }

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

  Future<void> refreshUser() async {
    try {
      final response = await AuthService.getProfile();
      if (response.success && response.data != null) {
        _user = response.data;
        notifyListeners();
      }
    } catch (_) {}
  }
}
