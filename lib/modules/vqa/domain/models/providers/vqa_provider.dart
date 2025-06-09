import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';

abstract class VqaProvider {
  Future<VqaResult> processCaptioning(VqaCaptioningInput captioningInput);
  Future<VqaResult> processQuestion(VqaQuestionInput questionInput);
}
