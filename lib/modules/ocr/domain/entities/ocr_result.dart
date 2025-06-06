import 'dart:ui';

class OcrResult {
  final String text;
  final double? confidence;
  final Rect box;

  OcrResult({required this.text, this.confidence, required this.box});
}

class OcrOutput {
  final List<OcrResult> texts;
  final Map<String, dynamic>? description;

  OcrOutput({required this.texts, this.description});
}
