import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sight_mate/app/config.dart';
import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';

class OcrConnectivityProviderImplConfig {
  static final Duration timeout = Duration(seconds: 2);
}

class OcrConnectivityProviderImpl extends OcrConnectivityProvider {
  @override
  Future<bool> isConnected() async {
    final uri = Uri.parse('${Config.ocrServiceApiBaseUrl}/health');

    try {
      final response = await http
          .get(uri)
          .timeout(OcrConnectivityProviderImplConfig.timeout);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
