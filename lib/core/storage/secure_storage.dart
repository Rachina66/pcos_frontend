import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // ═══ TOKEN HELPERS (used by AuthProvider) ═══
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  // ═══ GENERIC HELPERS (for other use cases) ═══
  static Future<void> writeData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> readData(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }
}
