class AsrResult {
  final String text;
  final double confidence;
  final bool isFinal;

  AsrResult({
    required this.text,
    required this.confidence,
    required this.isFinal,
  });
}
