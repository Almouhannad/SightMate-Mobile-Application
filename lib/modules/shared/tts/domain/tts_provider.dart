/// An abstract class that defines the contract for text-to-speech functionality.
/// 
/// This provider handles the core text-to-speech operations like speaking text,
/// stopping speech, and cleaning up resources.
abstract class TtsProvider {
  /// Converts the given text to speech and plays it.
  /// 
  /// [textToSpeak] is the text that will be converted to speech.
  Future<void> speak(String textToSpeak);

  /// Stops any ongoing text-to-speech playback immediately.
  Future<void> stop();

  /// Releases any resources used by the text-to-speech engine.
  /// 
  /// Should be called when the TTS functionality is no longer needed
  /// to prevent memory leaks.
  Future<void> dispose();
}
