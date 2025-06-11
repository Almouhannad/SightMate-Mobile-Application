import 'package:flutter/material.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/shared/asr/domain/asr_domin.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/vqa/presentation/vqa_presentation.dart';

// modal dialog that captures a user question via text or voice input
class VqaQuestionDialog extends StatefulWidget {
  final Future<void> Function(String) _handleSubmit;

  const VqaQuestionDialog({
    super.key,
    required Future<void> Function(String) handleSubmit,
  }) : _handleSubmit = handleSubmit;

  @override
  State<VqaQuestionDialog> createState() => _VqaQuestionDialogState();
}

class _VqaQuestionDialogState extends State<VqaQuestionDialog> {
  final TextEditingController _controller = TextEditingController();

  // Injected automatic speech recognition provider for voice input
  final _asrProvider = DI.get<AsrProvider>();

  // Handles text submission and closes the dialog before triggering the callback
  Future<void> onSubmit(BuildContext context, String text) async {
    if (text.isEmpty) return;
    Navigator.of(context).pop();
    await widget._handleSubmit(text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text(
        L10n.current.question,
        style: TextStyle(fontSize: kTitleFontSize, fontWeight: FontWeight.bold),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 300),
        child: IntrinsicHeight(
          //expands vertical as user types more lines
          child: TextField(
            controller: _controller,
            maxLines: null,
            style: const TextStyle(fontSize: kContentFontSize),
            decoration: InputDecoration(
              hintText: L10n.current.typeOrSpeak,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
      actions: [
        // Mic button triggers ASR and updates the text field with recognized speech
        Semantics(
          label: L10n.current.record,
          button: true,
          child: IconButton(
            tooltip: L10n.current.record,
            iconSize: kIconSize,
            onPressed: () async {
              await _asrProvider.listen((asrResult) {
                _controller.text = asrResult.text;
              });
            },
            icon: Icon(Icons.mic, semanticLabel: L10n.current.record),
          ),
        ),
        // Submit button sends the input and closes the dialog
        Semantics(
          label: L10n.current.submit,
          button: true,
          child: IconButton(
            tooltip: L10n.current.submit,
            iconSize: kIconSize,
            onPressed: () {
              onSubmit(context, _controller.text);
            },
            icon: Icon(Icons.send, semanticLabel: L10n.current.submit),
          ),
        ),
      ],
    );
  }
}
