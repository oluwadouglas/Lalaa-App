import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Provides the singleton AuthService instance.
final authServiceProvider = Provider<AuthService>((_) => AuthService());

/// Manages JWT token storage and retrieval.
class AuthService {
  static const _tokenKey = 'jwt_token';
  static const _userIdKey = 'user_id';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Read the stored JWT token, or null if not logged in.
  Future<String?> getToken() => _storage.read(key: _tokenKey);

  /// Save a JWT token after login/register.
  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  /// Save the user ID alongside the token.
  Future<void> saveUserId(String userId) =>
      _storage.write(key: _userIdKey, value: userId);

  /// Read the stored user ID.
  Future<String?> getUserId() => _storage.read(key: _userIdKey);

  /// Clear all stored credentials (logout).
  Future<void> clearCredentials() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userIdKey);
  }

  /// Returns true if a token is stored (user previously logged in).
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
