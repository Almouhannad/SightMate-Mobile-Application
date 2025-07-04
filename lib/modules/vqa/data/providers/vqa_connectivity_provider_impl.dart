import 'package:dio/dio.dart';
import 'package:sight_mate/app/config.dart';
import 'package:sight_mate/modules/shared/api_client/api_client.dart';
import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';

class VqaConnectivityProviderImplConfig {
  static final Duration timeout = Duration(seconds: 2);
}

class VqaConnectivityProviderImpl extends VqaConnectivityProvider {
  final ApiClient _client = ApiClient();
  final String _vqaApi = Config.vqaApi;
  final Duration _timeout = VqaConnectivityProviderImplConfig.timeout;

  @override
  Future<bool> get isConnected async {
    try {
      var healthResult = await _client.dio.get(
        "$_vqaApi/health",
        options: Options(sendTimeout: _timeout, receiveTimeout: _timeout),
      );
      return healthResult.data["status"] == "UP";
    } catch (e) {
      return false;
    }
  }
}
