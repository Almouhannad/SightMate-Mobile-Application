import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';

class VqaQuestionInput {
  final String conversationId;
  final String question;
  final Map<String, dynamic>? options;

  VqaQuestionInput({
    required this.conversationId,
    required this.question,
    this.options,
  });
}
