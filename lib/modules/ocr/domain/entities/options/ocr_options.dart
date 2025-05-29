import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';

class OcrOptions {
  final OcrLang lang;

  OcrOptions({OcrLang? lang}) : lang = lang ?? OCRLangs.EN;
}
