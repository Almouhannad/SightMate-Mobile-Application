import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Singleton
  SecureStorage._internal();
  static final SecureStorage instance = SecureStorage._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _keyAccess = 'ACCESS_TOKEN';

  Future<void> writeToken({required String accessToken}) async {
    await _storage.write(key: _keyAccess, value: accessToken);
  }

  Future<String?> readAccessToken() async {
    return _storage.read(key: _keyAccess);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _keyAccess);
  }
}
