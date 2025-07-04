import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sight_mate/app/config.dart';
import 'package:sight_mate/core/result.dart';
import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';

/// Implementation of VQA provider using HTTP REST API (Microservice)
/// Handles communication with the VQA service for image captioning and question answering
class VqaProviderImpl extends VqaProvider {
  final _captioningUri = Uri.parse(
    '${Config.vqaServiceApiBaseUrl}/vqa/captioning',
  );
  final _questionUri = Uri.parse('${Config.vqaServiceApiBaseUrl}/vqa/question');
  final _headers = {'Content-Type': 'application/json'};

  @override
  /// Process an image to generate a caption using the VQA service
  /// Sends image data and options to the captioning endpoint
  Future<Result<VqaResult>> processCaptioning(
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
    return Result(
      isSuccess: true,
      value: VqaResult(text: data['output'], details: data['details']),
    );
  }

  @override
  /// Process an image and question using the VQA service
  /// Sends image data question and options to the question endpoint
  Future<Result<VqaResult>> processQuestion(
    VqaQuestionInput questionInput,
  ) async {
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
    return Result(
      isSuccess: true,
      value: VqaResult(text: data['output'], details: data['details']),
    );
  }
}
