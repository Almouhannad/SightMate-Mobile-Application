import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';

abstract class OcrProvider {
  Future<List<OcrResult>> processImage(OcrInput input);
}
