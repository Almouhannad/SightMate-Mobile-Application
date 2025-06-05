/// An abstract class that defines the contract for text-to-speech functionality.
///
/// This provider handles the core text-to-speech operations like speaking text,
/// stopping speech, and cleaning up resources.
abstract class TtsProvider {
  /// initilize provider
  Future<void> initilize();

  /// Converts the given text to speech and plays it.
  ///
  /// [textToSpeak] is the text that will be converted to speech.
  Future<void> speak(String textToSpeak);

  /// Stops any ongoing text-to-speech playback immediately.
  Future<void> stop();

  /// Waits for any ongoing text-to-speech playback to complete.
  ///
  /// This method blocks execution until the current speech is finished.
  /// Useful when you need to ensure speech completion before proceeding.
  Future<void> waitToEnd();

  /// Releases any resources used by the text-to-speech engine.
  ///
  /// Should be called when the TTS functionality is no longer needed
  /// to prevent memory leaks.
  Future<void> dispose();
}
