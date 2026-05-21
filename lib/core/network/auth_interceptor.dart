import 'package:dio/dio.dart';
import '../services/auth_service.dart';

/// Dio interceptor that attaches the JWT token to every outgoing request
/// and handles 401 (unauthorized) responses.
class AuthInterceptor extends Interceptor {
  final AuthService _authService;
  final void Function()? onUnauthorized;

  AuthInterceptor(this._authService, {this.onUnauthorized});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _authService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _authService.clearCredentials();
      onUnauthorized?.call();
    }
    handler.next(err);
  }
}
