import 'dart:collection';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/core/result.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';

/// Manages visual question answering operations and history
/// Provides high level methods for image captioning and question answering
class VqaUsecase {
  final _vqaProvider = DI.get<VqaProvider>();
  final List<VqaHistoryItem> _historyItems = [];
  bool _hasCaption = false;
  String? _conversationId;

  /// Get a read-only view of the VQA history items
  List<VqaHistoryItem> get historyItems =>
      UnmodifiableListView(_historyItems); // Read only list (Iterator pattern)

  /// Generate a caption for an image provided as bytes
  /// Stores the result in history and returns the caption text
  Future<String> captionImage() async {
    final vqaResult = await _vqaProvider.processCaptioning(
      VqaCaptioningInput(conversationId: _conversationId!),
    );
    if (!vqaResult.isSuccess) {
      return L10n.current.errorOccurred;
    }
    _historyItems.add(
      VqaHistoryItem(
        title: L10n.current.imageCaption,
        text: vqaResult.value!.text,
      ),
    );
    _conversationId = vqaResult.value!.conversationId!;
    _hasCaption = true;
    return vqaResult.value!.text;
  }

  /// Answer a question about an image provided as bytes
  /// Stores the result in history and returns the answer text
  Future<String> answerQuestion(String question) async {
    final vqaResult = await _vqaProvider.processQuestion(
      VqaQuestionInput(conversationId: _conversationId!, question: question),
    );
    if (!vqaResult.isSuccess) {
      return L10n.current.errorOccurred;
    }
    int lastIndex = _historyItems.length;
    if (!_hasCaption) {
      lastIndex++;
    }
    _historyItems.add(
      VqaHistoryItem(
        title: '${L10n.current.question} $lastIndex',
        text: vqaResult.value!.text,
        question: question,
      ),
    );
    return vqaResult.value!.text;
  }

  Future<Result> createConversationFromImageBytes(List<int> imageBytes) async {
    final createResult = await _vqaProvider.createConversation(
      VqaImageInput(bytes: imageBytes),
    );
    if (!createResult.isSuccess) {
      return Result(isSuccess: false);
    }
    _conversationId = createResult.value!;
    return Result(isSuccess: true);
  }
}
