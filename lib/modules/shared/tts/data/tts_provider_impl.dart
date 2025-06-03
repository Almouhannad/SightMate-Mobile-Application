import 'package:flutter_tts/flutter_tts.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';

/// Implementation of [TtsProvider] using the flutter_tts package.
class TtsProviderImpl extends TtsProvider {
  // Instance of FlutterTts that handles the actual text-to-speech functionality
  late FlutterTts _tts;

  /// Creates a new instance of TtsProviderImpl and initializes the FlutterTts engine.
  TtsProviderImpl() {
    _tts = FlutterTts();
  }

  @override
  Future<void> speak(String textToSpeak) async {
    // Convert the text to speech and play it
    await _tts.speak(textToSpeak);
    // Note: Uncomment the following line if you want to wait for speech completion
    // but this won't be go well if you want to stop speech after some user interaction
    // await _tts.awaitSpeakCompletion(true);
  }

  @override
  Future<void> stop() async {
    // Stop any ongoing speech immediately
    await _tts.stop();
  }

  @override
  Future<void> dispose() async {
    // Clean up by stopping any ongoing speech before disposal
    await _tts.stop();
  }

  @override
  Future<void> waitToEnd() async {
    await _tts.awaitSpeakCompletion(true);
  }
}
