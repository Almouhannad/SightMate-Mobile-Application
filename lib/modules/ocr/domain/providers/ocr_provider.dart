import 'package:sight_mate/core/result.dart';
import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';

abstract class OcrProvider {
  Future<Result<OcrOutput>> processImage(OcrInput input);

  void dispose();
}
