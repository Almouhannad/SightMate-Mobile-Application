import 'package:sight_mate/core/result.dart';
import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';

/// Provides visual question answering capabilities
/// This abstract class defines the contract for VQA service implementations
abstract class VqaProvider {
  /// Process an image to generate a natural language caption
  /// Returns a VqaResult containing the generated caption
  Future<Result<VqaResult>> processCaptioning(
    VqaCaptioningInput captioningInput,
  );

  /// Process an image and question to generate an answer
  /// Returns a VqaResult containing the answer to the question about the image
  Future<Result<VqaResult>> processQuestion(VqaQuestionInput questionInput);
}
