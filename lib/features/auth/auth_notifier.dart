import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/user.dart';
import 'auth_repository.dart';

/// Provides the current authenticated user state.
final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(AuthNotifier.new);

/// Manages authentication state across the app.
class AuthNotifier extends AsyncNotifier<User?> {
  late final AuthRepository _repository;

  @override
  FutureOr<User?> build() async {
    _repository = ref.read(authRepositoryProvider);
    // Check if user is already logged in
    return _repository.getCurrentUser();
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() =>
        _repository.login(email: email, password: password));
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() =>
        _repository.register(name: name, email: email, password: password));
  }

  Future<void> forgotPassword({required String email}) async {
    await _repository.forgotPassword(email: email);
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AsyncValue.data(null);
  }
}
