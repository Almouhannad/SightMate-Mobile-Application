import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';

class OcrInput {
  late List<int> bytes;
  late Map<String, dynamic>? metadata;
  late OcrOptions options;

  OcrInput({required this.bytes, this.metadata, OcrOptions? options}) {
    this.options = options ?? OcrOptions(lang: OCRLangs.EN);
  }
}
