import 'package:dio/dio.dart';
import 'package:sight_mate/app/config.dart';
import 'package:sight_mate/modules/shared/api_client/secure_storage.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;
  factory ApiClient() => _instance;

  ApiClient._internal() {
    dio = Dio(BaseOptions(baseUrl: Config.backendApiBaseUri));
    dio.interceptors.add(AuthInterceptor());
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) {
    return dio.get(path, queryParameters: query);
  }

  Future<Response> post(String path, {dynamic body}) {
    return dio.post(path, data: body);
  }
}

class AuthInterceptor extends Interceptor {
  final SecureStorage _storage = SecureStorage.instance;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.readAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
