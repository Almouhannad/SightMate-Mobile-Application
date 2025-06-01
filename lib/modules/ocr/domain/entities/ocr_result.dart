import 'dart:ui';

class OcrResult {
  final String text;
  final double? confidence;
  final Rect box;

  OcrResult({required this.text, this.confidence, required this.box});
}
