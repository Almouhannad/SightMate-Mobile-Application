import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:sight_mate/app/config.dart';
import 'package:sight_mate/core/result.dart';
import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';
import 'package:sight_mate/modules/shared/api_client/api_client.dart';

class OcrProviderOnlineImpl extends OcrProvider {
  final ApiClient _client = ApiClient();
  final _ocrApi = Config.ocrApi;
  @override
  Future<Result<OcrOutput>> processImage(OcrInput input) async {
    var payload = {
      "ImageBytes": input.bytes,
      "ImageMetadata": input.metadata,
      "LanguageCode": input.options.lang.lang,
    };
    Response processOcrResult;
    try {
      processOcrResult = await _client.post("$_ocrApi/ocr", body: payload);
      if (processOcrResult.statusCode != 200) {
        return Result(isSuccess: false);
      }
    } catch (e) {
      return Result(isSuccess: false);
    }
    var processOcrValue = processOcrResult.data;
    List<OcrResult> detectedTexts = [];
    for (var detectedTextItem in processOcrValue["detectedTexts"]) {
      var detectedTextItemRect = detectedTextItem["box"];
      var rectItem = Rect.fromLTRB(
        detectedTextItemRect["left"].toDouble(),
        detectedTextItemRect["top"].toDouble(),
        detectedTextItemRect["right"].toDouble(),
        detectedTextItemRect["bottom"].toDouble(),
      );
      detectedTexts.add(
        OcrResult(
          text: detectedTextItem["text"],
          box: rectItem,
          confidence: detectedTextItem["confidence"],
        ),
      );
    }
    return Result(
      isSuccess: true,
      value: OcrOutput(
        texts: detectedTexts,
        description: processOcrValue["description"],
      ),
    );
  }

  @override
  void dispose() {
    // Nothing to do
  }
}
