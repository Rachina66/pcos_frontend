import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Content-Type'] = 'application/json';
    print('→ ${options.method} ${options.path}');
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✓ ${response.statusCode} ${response.requestOptions.path}');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('✗ ${err.response?.statusCode} ${err.requestOptions.path}');
    if (err.response?.statusCode == 401) {
      await SecureStorage.deleteToken();
      print('✗ Token expired, user must login again');
    }
    return handler.next(err);
  }
}
