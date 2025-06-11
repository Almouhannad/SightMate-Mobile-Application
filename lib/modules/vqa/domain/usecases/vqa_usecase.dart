import 'dart:collection';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';

/// Manages visual question answering operations and history
/// Provides high level methods for image captioning and question answering
class VqaUsecase {
  final _vqaProvider = DI.get<VqaProvider>();
  final List<VqaHistoryItem> _historyItems = [];

  /// Get a read-only view of the VQA history items
  List<VqaHistoryItem> get historyItems =>
      UnmodifiableListView(_historyItems); // Read only list (Iterator pattern)

  /// Generate a caption for an image provided as bytes
  /// Stores the result in history and returns the caption text
  Future<String> captionImageBytes(List<int> imageBytes) async {
    try {
      final vqaResult = await _vqaProvider.processCaptioning(
        VqaCaptioningInput(imageInput: VqaImageInput(bytes: imageBytes)),
      );
      _historyItems.add(
        VqaHistoryItem(title: L10n.current.imageCaption, text: vqaResult.text),
      );
      return vqaResult.text;
    } catch (e) {
      return L10n.current.errorOccurred;
    }
  }

  /// Answer a question about an image provided as bytes
  /// Stores the result in history and returns the answer text
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
      final lastIndex = _historyItems.length;
      _historyItems.add(
        VqaHistoryItem(
          title: '${L10n.current.question} $lastIndex',
          text: vqaResult.text,
          question: question,
        ),
      );
      return vqaResult.text;
    } catch (e) {
      return L10n.current.errorOccurred;
    }
  }
}
