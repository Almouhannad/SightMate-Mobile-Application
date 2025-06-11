import 'package:sight_mate/modules/shared/asr/domain/asr_domin.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Implementation of ASR provider using speech_to_text package
/// Handles speech recognition operations using the device's native capabilities
class AsrProviderImpl extends AsrProvider {
  final SpeechToText _speechToText = SpeechToText();

  @override
  Future<bool> initilize() {
    return _speechToText.initialize();
  }

  @override
  Future listen(Function(AsrResult asrResult) onResult) {
    return _speechToText.listen(
      onResult: (result) => onResult(convertResult(result)),
    );
  }

  @override
  Future<void> stopListening() {
    return _speechToText.stop();
  }

  /// Convert speech recognition result to our domain model
  /// Maps confidence scores and recognized text to ASR result format
  AsrResult convertResult(SpeechRecognitionResult modelResult) {
    return AsrResult(
      text: modelResult.recognizedWords,
      confidence: modelResult.confidence == -1 ? 0 : modelResult.confidence,
      isFinal: modelResult.finalResult,
    );
  }
}
