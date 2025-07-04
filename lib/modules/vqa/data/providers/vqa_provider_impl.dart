import 'package:dio/dio.dart';
import 'package:sight_mate/app/config.dart';
import 'package:sight_mate/core/result.dart';
import 'package:sight_mate/modules/shared/api_client/api_client.dart';
import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';

/// Implementation of VQA provider using HTTP REST API (Microservice)
/// Handles communication with the VQA service for image captioning and question answering
class VqaProviderImpl extends VqaProvider {
  final ApiClient _client = ApiClient();
  final String _vqaApi = Config.vqaApi;

  @override
  /// Process an image to generate a caption using the VQA service
  /// Sends image data and options to the captioning endpoint
  Future<Result<VqaResult>> processCaptioning(
    VqaCaptioningInput captioningInput,
  ) async {
    var payload = {
      "ImageBytes": captioningInput.imageInput.bytes,
      "ImageMetadata": captioningInput.imageInput.metadata,
    };
    Response captioningResponse;
    try {
      captioningResponse = await _client.post("$_vqaApi/ic", body: payload);
      if (captioningResponse.statusCode != 200) {
        return Result(isSuccess: false);
      }
    } catch (e) {
      return Result(isSuccess: false);
    }
    var captioningValue = captioningResponse.data;
    return Result(
      isSuccess: true,
      value: VqaResult(
        text: captioningValue["caption"],
        conversationId: captioningValue["conversationId"],
      ),
    );
  }

  @override
  /// Process an image and question using the VQA service
  /// Sends image data question and options to the question endpoint
  Future<Result<VqaResult>> processQuestion(
    VqaQuestionInput questionInput,
  ) async {
    var payload = {
      "ConversationId": questionInput.conversationId,
      "Question": questionInput.question,
    };
    Response questionResponse;
    try {
      questionResponse = await _client.post("$_vqaApi/vqa", body: payload);
      if (questionResponse.statusCode != 200) {
        return Result(isSuccess: false);
      }
    } catch (e) {
      return Result(isSuccess: false);
    }
    var questionValue = questionResponse.data;
    return Result(
      isSuccess: true,
      value: VqaResult(text: questionValue["answer"]),
    );
  }
}
