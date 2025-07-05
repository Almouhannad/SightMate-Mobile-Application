import 'package:dio/dio.dart';
import 'package:sight_mate/app/config.dart';
import 'package:sight_mate/modules/shared/api_client/secure_storage.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;
  factory ApiClient() => _instance;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: Config.backendApiBaseUri,
        validateStatus: (status) {
          return status != null && status < 600;
        },
      ),
    );

    // 1) attach auth interceptor
    dio.interceptors.add(AuthInterceptor());

    // 2) attach bad-request filter interceptor
    dio.interceptors.add(BadRequestInterceptor());
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

class BadRequestInterceptor extends Interceptor {
  final _validationErrorsProperty = Config.serverValidationErrorsPropertyName;
  final _validationErrorDescriptionProperty =
      Config.serverValidationErrorDescriptionPropertyName;
  final _clientValidationErrorsProperty =
      Config.clientValidationErrorsPropertyName;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    if (response != null && response.statusCode == 400) {
      List<String> validationErrors = [];
      for (var validationError in response.data[_validationErrorsProperty]) {
        validationErrors.add(
          validationError[_validationErrorDescriptionProperty],
        );
      }
      handler.resolve(
        Response(
          requestOptions: err.requestOptions,
          statusCode: 400,
          data: {_clientValidationErrorsProperty: validationErrors},
        ),
      );
    } else {
      // Not 400, let it go
      handler.next(err);
    }
  }
}
