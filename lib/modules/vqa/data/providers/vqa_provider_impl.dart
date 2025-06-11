import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sight_mate/app/config.dart';
import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';

class VqaProviderImpl extends VqaProvider {
  final _captioningUri = Uri.parse(
    '${Config.vqaServiceApiBaseUrl}/vqa/captioning',
  );
  final _questionUri = Uri.parse('${Config.vqaServiceApiBaseUrl}/vqa/question');
  final _headers = {'Content-Type': 'application/json'};

  @override
  Future<VqaResult> processCaptioning(
    VqaCaptioningInput captioningInput,
  ) async {
    final response = await http.post(
      _captioningUri,
      headers: _headers,
      body: jsonEncode({
        'image': {
          'bytes': captioningInput.imageInput.bytes,
          'metadata': captioningInput.imageInput.metadata,
        },
        'options': captioningInput.options,
      }),
    );

    final data = jsonDecode(response.body);
    return VqaResult(text: data['output'], details: data['details']);
  }

  @override
  Future<VqaResult> processQuestion(VqaQuestionInput questionInput) async {
    final response = await http.post(
      _questionUri,
      headers: _headers,
      body: jsonEncode({
        'image': {
          'bytes': questionInput.imageInput.bytes,
          'metadata': questionInput.imageInput.metadata,
        },
        'question': questionInput.question,
        'options': questionInput.options,
      }),
    );

    final data = jsonDecode(response.body);
    return VqaResult(text: data['output'], details: data['details']);
  }
}
