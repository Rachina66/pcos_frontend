// lib/providers/profile/profile_provider.dart

import 'package:flutter/material.dart';
import '../../core/api/api_exception.dart';
import '../../services/profile/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _service = ProfileService();

  bool _isLoading = false;
  String? _error;
  String? _pendingEmail; // email waiting for OTP during forgot password

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get pendingEmail => _pendingEmail;

  // ── Update name ──
  Future<String?> updateName(String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.updateName(name);
      return null; // success
    } on ApiException catch (e) {
      _error = e.message;
      return e.message;
    } catch (e) {
      _error = 'Something went wrong.';
      return _error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Change password
  Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return null; // success
    } on ApiException catch (e) {
      _error = e.message;
      return e.message;
    } catch (e) {
      _error = 'Something went wrong.';
      return _error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Forgot password — send OTP
  Future<String?> forgotPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.forgotPassword(email);
      _pendingEmail = email;
      return null; // success
    } on ApiException catch (e) {
      _error = e.message;
      return e.message;
    } catch (e) {
      _error = 'Something went wrong.';
      return _error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Verify OTP ──
  Future<String?> verifyOtp(String otp) async {
    if (_pendingEmail == null) return 'No email found.';
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.verifyOtp(email: _pendingEmail!, otp: otp);
      return null; // success
    } on ApiException catch (e) {
      _error = e.message;
      return e.message;
    } catch (e) {
      _error = 'Something went wrong.';
      return _error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //  Reset password
  Future<String?> resetPassword(String newPassword) async {
    if (_pendingEmail == null) return 'No email found.';
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.resetPassword(
        email: _pendingEmail!,
        newPassword: newPassword,
      );
      _pendingEmail = null;
      return null; // success
    } on ApiException catch (e) {
      _error = e.message;
      return e.message;
    } catch (e) {
      _error = 'Something went wrong.';
      return _error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
