import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';

class OcrProviderOfflineImpl extends OcrProvider {
  final _textRecognizer = TextRecognizer();

  @override
  Future<OcrOutput> processImage(OcrInput input) async {
    // Create tmp. directory to store image before processing
    final dir = await getTemporaryDirectory();
    final outFile = File('${dir.path}/temp_for_ocr.png');
    await outFile.writeAsBytes(input.bytes);

    // Load input as InputImage
    final inputImage = InputImage.fromFilePath(outFile.path);

    // Perform OCR
    final recognized = await _textRecognizer.processImage(inputImage);

    // Map results
    List<OcrResult> results = [];
    recognized.blocks.expand((block) => block.lines).forEach((line) {
      results.add(
        OcrResult(
          text: line.text,
          confidence: line.confidence,
          box: line.boundingBox,
        ),
      );
    });
    return OcrOutput(texts: results);
  }

  @override
  void dispose() {
    _textRecognizer.close();
  }
}
