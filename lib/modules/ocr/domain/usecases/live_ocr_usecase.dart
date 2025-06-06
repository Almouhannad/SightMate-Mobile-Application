import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';

class LiveOcrUsecaseConfig {
  static final Duration frameInterval = Duration(milliseconds: 1000);
  static final Duration repeatInterval = Duration(seconds: 10);
  static final double confidenceThreshold = 0.2;
  static final int maximumLength = 50;
}

class LiveOcrUsecase {
  final Map<String, DateTime> _lastDetectedIn = {};
  late OcrProvider _ocrProvider;

  Duration get frameInterval => LiveOcrUsecaseConfig.frameInterval;

  Future<String> processFrameBytes(List<int> bytes) async {
    _ocrProvider = DI.get<OcrProvider>(instanceName: OcrProviderModes.OFFLINE);

    List<OcrResult> results = [];
    await _ocrProvider
        .processImage(OcrInput(bytes: bytes))
        .then((value) => results = value.texts);

    String textToSpeak = '';
    final DateTime now = DateTime.now();
    for (var result in results) {
      if (shouldSpeak(result, now)) {
        textToSpeak += '${result.text.toLowerCase()}\n';
        _lastDetectedIn[result.text.toLowerCase()] = now;
      }
    }
    return textToSpeak;
  }

  bool shouldSpeak(OcrResult ocrResult, DateTime now) {
    bool result = true;

    // Last sopken time
    final lastSpokenTime = _lastDetectedIn[ocrResult.text.toLowerCase()];
    result &=
        (lastSpokenTime == null ||
            now.difference(lastSpokenTime) >=
                LiveOcrUsecaseConfig.repeatInterval);

    final confidence = ocrResult.confidence ?? 0.0;
    result &= confidence >= LiveOcrUsecaseConfig.confidenceThreshold;

    final textLength = ocrResult.text.length;
    result &= textLength <= LiveOcrUsecaseConfig.maximumLength;

    return result;
  }
}
