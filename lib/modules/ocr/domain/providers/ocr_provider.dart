import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';

abstract class OcrProvider {
  Future<OcrOutput> processImage(OcrInput input);

  void dispose();
}
