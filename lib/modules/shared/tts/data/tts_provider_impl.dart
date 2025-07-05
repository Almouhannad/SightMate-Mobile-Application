import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';

/// Implementation of [TtsProvider] using the flutter_tts package.
class TtsProviderImpl extends TtsProvider {
  // Instance of FlutterTts that handles the actual text-to-speech functionality
  late FlutterTts _tts;

  @override
  Future<void> initilize() async {
    final locale =
        DI.get<I18nNotifier>().locale ?? L10n.delegate.supportedLocales.first;
    _tts = FlutterTts();
    if (Platform.isAndroid) {
      // Force Google’s TTS engine on Android
      await _tts.setEngine('com.google.android.tts');
    } else if (Platform.isIOS) {
      // Use the shared AVSpeechSynthesizer on iOS 13+
      await _tts.setSharedInstance(true);
    }
    await _tts.setLanguage(locale.languageCode);
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

  @override
  Future<void> stopAndSpeak(String textToSpeak) async {
    await stop();
    await speak(textToSpeak);
  }
}
