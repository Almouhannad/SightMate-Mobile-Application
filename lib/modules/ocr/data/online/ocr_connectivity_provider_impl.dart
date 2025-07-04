import 'dart:async';
import 'package:dio/dio.dart';
import 'package:sight_mate/app/config.dart';
import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';
import 'package:sight_mate/modules/shared/api_client/api_client.dart';

class OcrConnectivityProviderImplConfig {
  static final Duration timeout = Duration(seconds: 2);
}

class OcrConnectivityProviderImpl extends OcrConnectivityProvider {
  final ApiClient _client = ApiClient();
  final String _ocrApi = Config.ocrApi;
  final Duration _timeout = OcrConnectivityProviderImplConfig.timeout;

  @override
  Future<bool> isConnected() async {
    try {
      var healthResult = await _client.dio.get(
        "$_ocrApi/health",
        options: Options(sendTimeout: _timeout, receiveTimeout: _timeout),
      );
      return healthResult.data["status"] == "UP";
    } catch (e) {
      return false;
    }
  }
}
