import 'dart:typed_data';

import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';

class CaptureOcrUsecaseConfig {
  static final double confidenceThreshold = 0.2;
  static final int minWidth = 32;
  static final int minHeight = 32;
}

class CaptureOcrUsecase {
  final _ocrProvider = DI.get<OcrProvider>(
    instanceName: OcrProviderModes.OFFLINE,
  );

  Future<String> processCapture(Uint8List bytes) async {
    List<OcrResult> recognized = [];
    await _ocrProvider.processImage(OcrInput(bytes: bytes)).then((result) {
      if (!result.isSuccess) {
        return L10n.current.errorOccurred;
      }
      recognized = result.value!.texts;
    });

    String textToSpeak = '';
    for (var ocrResult in recognized) {
      if (shouldSpeak(ocrResult)) {
        textToSpeak += '${ocrResult.text.toLowerCase()}\n';
      }
      if (textToSpeak.endsWith("\n")) {
        textToSpeak = textToSpeak.substring(0, textToSpeak.length - 1);
      }
    }

    if (textToSpeak.isEmpty) {
      return L10n.current.noTextDetected;
    }
    return textToSpeak;
  }

  bool shouldSpeak(OcrResult ocrResult) {
    bool result = true;
    result &=
        (ocrResult.confidence ?? 0.0) >=
        CaptureOcrUsecaseConfig.confidenceThreshold;
    return result;
  }
}
