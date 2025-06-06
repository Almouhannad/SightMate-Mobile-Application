import 'dart:typed_data';

import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';
import 'package:sight_mate/modules/shared/i18n/data/l10n/l10n.dart';

class DescribeOcrUsecase {
  final _ocrProvider = DI.get<OcrProvider>(
    instanceName: OcrProviderModes.ONLINE,
  );

  Future<String> processCapture(Uint8List bytes) async {
    String description = '';
    try {
      await _ocrProvider
          .processImage(OcrInput(bytes: bytes))
          .then((value) => description = value.description!['sentence'] ?? '');
    } catch (e) {
      return L10n.current.errorOccurred;
    }
    return description.toLowerCase();
  }
}
