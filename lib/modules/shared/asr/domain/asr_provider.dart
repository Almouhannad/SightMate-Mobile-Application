import 'asr_domin.dart';

/// Provides automatic speech recognition capabilities
/// This abstract class defines the contract for ASR implementations
abstract class AsrProvider {
  /// Initialize the speech recognition service
  /// Returns true if initialization was successful
  Future<bool> initilize();

  /// Start listening for speech input
  /// The onResult callback will be called with ASR results as they come in
  Future<dynamic> listen(dynamic Function(AsrResult) onResult);

  /// Stop the speech recognition service from listening
  Future<void> stopListening();
}
