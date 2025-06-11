import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';

class VqaCaptioningInput {
  final VqaImageInput imageInput;
  final Map<String, dynamic>? options;

  VqaCaptioningInput({required this.imageInput, this.options});
}
