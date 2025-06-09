import 'package:http/http.dart' as http;
import 'package:sight_mate/app/config.dart';
import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';

class VqaConnectivityProviderImplConfig {
  static final Duration timeout = Duration(seconds: 2);
}

class VqaConnectivityProviderImpl extends VqaConnectivityProvider {
  final _uri = Uri.parse('${Config.vqaServiceApiBaseUrl}/health');

  @override
  Future<bool> get isConnected async {
    try {
      // await Future.delayed(Duration(seconds: 5));
      final response = await http
          .get(_uri)
          .timeout(VqaConnectivityProviderImplConfig.timeout);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
