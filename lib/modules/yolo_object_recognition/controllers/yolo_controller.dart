import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';
import 'package:sight_mate/modules/yolo_object_recognition/config/yolo_object_recognition_config.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class YoloController {
  YOLOViewController? _controller;
  final _config = YoloObjectRecognitionConfig();
  final _ttsProvider = DI.get<TtsProvider>();
  final Map<String, DateTime> _lastSpokenAt = {};
  bool _isSpeaking = false;

  Future<void> initilize() async {
    if (_controller == null) {
      _controller = YOLOViewController();
      await _controller!.setThresholds(
        confidenceThreshold: _config.confidenceThreshold,
        iouThreshold: _config.iouThreshold,
        numItemsThreshold: _config.numItemsThreshold,
      );
      await _controller!.setStreamingConfig(_config.streamingConfig);
    }
    return;
  }

  Future<YOLOViewController> get controller async {
    if (_controller == null) {
      await initilize();
    }
    return _controller!;
  }

  Future<void> processResults(List<YOLOResult> results) async {
    if (_isSpeaking) return;
    final now = DateTime.now();
    for (var result in results) {
      if (_shouldSpeak(result, now)) {
        _isSpeaking = true;
        _lastSpokenAt[result.className] = now;
        await _ttsProvider.speak(result.className);
        await Future.delayed(_config.waitInterval);
      }
    }
    _isSpeaking = false;
  }

  bool _shouldSpeak(YOLOResult result, DateTime now) {
    final lastSpokenTime = _lastSpokenAt[result.className.toLowerCase()];
    return (lastSpokenTime == null ||
        now.difference(lastSpokenTime) >= _config.repeatInterval);
  }
}
