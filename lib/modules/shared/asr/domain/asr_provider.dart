import 'asr_domin.dart';

abstract class AsrProvider {
  Future<bool> initilize();

  Future<dynamic> listen(dynamic Function(AsrResult) onResult);

  Future<void> stopListening();
}
