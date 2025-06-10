import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';

class VqaUsecase {
  final _vqaProvider = DI.get<VqaProvider>();

  Future<String> captionImageBytes(List<int> imageBytes) async {
    try {
      final vqaResult = await _vqaProvider.processCaptioning(
        VqaCaptioningInput(imageInput: VqaImageInput(bytes: imageBytes)),
      );
      return vqaResult.text;
    } catch (e) {
      return L10n.current.errorOccurred;
    }
  }

  Future<String> answerQuestionFromImageBytees(
    List<int> imageBytes,
    String question,
  ) async {
    try {
      final vqaResult = await _vqaProvider.processQuestion(
        VqaQuestionInput(
          imageInput: VqaImageInput(bytes: imageBytes),
          question: question,
        ),
      );
      return vqaResult.text;
    } catch (e) {
      return L10n.current.errorOccurred;
    }
  }
}
