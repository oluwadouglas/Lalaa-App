import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/services/auth_service.dart';
import '../../shared/models/user.dart';

/// Provides the active AuthRepository implementation.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // Using mock repository — swap to RemoteAuthRepository when backend is ready
  return MockAuthRepository(ref.read(authServiceProvider));
});

/// Abstract contract for authentication operations.
abstract class AuthRepository {
  Future<User> login({required String email, required String password});
  Future<User> register({required String name, required String email, required String password});
  Future<void> forgotPassword({required String email});
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> isLoggedIn();
}

/// Mock implementation that works without a backend.
class MockAuthRepository implements AuthRepository {
  final AuthService _authService;

  MockAuthRepository(this._authService);

  @override
  Future<User> login({required String email, required String password}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Accept any email/password combo for demo
    final user = User.demo().copyWith(email: email);
    await _authService.saveToken('mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}');
    await _authService.saveUserId(user.id);
    return user;
  }

  @override
  Future<User> register({required String name, required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final user = User.demo().copyWith(name: name, email: email);
    await _authService.saveToken('mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}');
    await _authService.saveUserId(user.id);
    return user;
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Mock: always succeeds
  }

  @override
  Future<void> logout() async {
    await _authService.clearCredentials();
  }

  @override
  Future<User?> getCurrentUser() async {
    final isAuth = await _authService.isLoggedIn();
    if (!isAuth) return null;
    return User.demo();
  }

  @override
  Future<bool> isLoggedIn() => _authService.isLoggedIn();
}

/// Remote implementation connecting to FastAPI backend.
class RemoteAuthRepository implements AuthRepository {
  final ApiClient _apiClient;
  final AuthService _authService;

  RemoteAuthRepository(this._apiClient, this._authService);

  @override
  Future<User> login({required String email, required String password}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'email': email.trim(), 'password': password},
    );

    final data = response.data!;
    final token = data['access_token'] ?? data['token'];
    if (token is! String || token.isEmpty) {
      throw const FormatException('Invalid login response from server.');
    }

    await _authService.saveToken(token);
    final user = User.fromJson(data['user'] as Map<String, dynamic>);
    await _authService.saveUserId(user.id);
    return user;
  }

  @override
  Future<User> register({required String name, required String email, required String password}) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: {'name': name.trim(), 'email': email.trim(), 'password': password},
    );

    final data = response.data!;
    final token = data['access_token'] ?? data['token'];
    if (token is! String || token.isEmpty) {
      throw const FormatException('Invalid registration response.');
    }

    await _authService.saveToken(token);
    final user = User.fromJson(data['user'] as Map<String, dynamic>);
    await _authService.saveUserId(user.id);
    return user;
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _apiClient.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email.trim()},
    );
  }

  @override
  Future<void> logout() async {
    await _authService.clearCredentials();
  }

  @override
  Future<User?> getCurrentUser() async {
    final isAuth = await _authService.isLoggedIn();
    if (!isAuth) return null;
    final response = await _apiClient.get<Map<String, dynamic>>(ApiEndpoints.profile);
    return User.fromJson(response.data!);
  }

  @override
  Future<bool> isLoggedIn() => _authService.isLoggedIn();
}
