import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';

class VqaQuestionInput {
  final VqaImageInput imageInput;
  final String question;
  final Map<String, dynamic>? options;

  VqaQuestionInput({
    required this.imageInput,
    required this.question,
    this.options,
  });
}
