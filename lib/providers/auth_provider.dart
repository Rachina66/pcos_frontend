import 'package:flutter/foundation.dart';
import '../models/auth/user_model.dart';
import '../models/auth/register_request_model.dart';
import '../models/auth/login_request_model.dart';
import '../services/auth/auth_service.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService();

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Initialize auth state (call this on app start)
  Future<void> initializeAuth() async {
    _setLoading(true);

    try {
      final isAuth = await _authService.isAuthenticated();

      if (isAuth) {
        final storedUser = await _authService.getStoredUser();
        if (storedUser != null) {
          _user = storedUser;
          _status = AuthStatus.authenticated;
        } else {
          _status = AuthStatus.unauthenticated;
        }
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? role,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final request = RegisterRequest(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      final response = await _authService.register(request);

      if (response.success && response.data != null) {
        _user = response.data!.user;
        _status = AuthStatus.authenticated;
        _setLoading(false);
        return true;
      } else {
        _errorMessage = response.message;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Login existing user
  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    try {
      final request = LoginRequest(email: email, password: password);

      final response = await _authService.login(request);

      if (response.success && response.data != null) {
        _user = response.data!.user;
        _status = AuthStatus.authenticated;
        _setLoading(false);
        return true;
      } else {
        _errorMessage = response.message;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Fetch current user profile
  Future<bool> fetchProfile() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authService.getProfile();

      if (response.success && response.data != null) {
        _user = response.data;
        _status = AuthStatus.authenticated;
        _setLoading(false);
        return true;
      } else {
        _errorMessage = response.message;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authService.logout();
      _user = null;
      _status = AuthStatus.unauthenticated;
      _clearError();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Check if user has specific role
  bool hasRole(String role) {
    return _user?.role == role;
  }

  // Check if user is admin
  bool get isAdmin => hasRole('ADMIN');

  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
