import 'package:flutter/material.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';
import 'package:sight_mate/modules/vqa/domain/vqa_domain.dart';
import 'package:sight_mate/modules/vqa/presentation/vqa_presentation.dart';

// Widget to display a single VQA history item
class VqaHistoryItemWidget extends StatefulWidget {
  final VqaHistoryItem item;

  const VqaHistoryItemWidget({super.key, required this.item});

  @override
  State<VqaHistoryItemWidget> createState() => _VqaHistoryItemWidgetState();
}

class _VqaHistoryItemWidgetState extends State<VqaHistoryItemWidget> {
  late bool _isQuestion;
  final _ttsProvider = DI.get<TtsProvider>(); // fetch TTS service from DI

  @override
  void initState() {
    super.initState();
    _isQuestion =
        (widget.item.question != null); // determine if this is a question item
  }

  //open dialog with detailed view
  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return VqaHistoryItemDetailDialog(
          widget: widget,
          isQuestion: _isQuestion,
          onReplay: _onReplay,
        );
      },
    );
  }

  // replay the question and answer using TTS
  Future<void> _onReplay() async {
    await _ttsProvider.stop();
    await _ttsProvider.speak(widget.item.textToSpeak);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.primary,
      margin: const EdgeInsets.all(kCardMargin),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: kContentPadding,
          horizontal: kContentPadding,
        ),
        title: Text(
          widget.item.title,
          style: const TextStyle(
            fontSize: kTitleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => _showDetailDialog(context),
        trailing: Semantics(
          label: L10n.current.replay,
          button: true,
          child: IconButton(
            tooltip: L10n.current.replay,
            iconSize: kIconSize,
            onPressed: () async {
              await _onReplay();
            },
            icon: Icon(Icons.replay, semanticLabel: L10n.current.replay),
          ),
        ),
      ),
    );
  }
}

// Dialog showing the full question and answer content (or caption)
class VqaHistoryItemDetailDialog extends StatelessWidget {
  const VqaHistoryItemDetailDialog({
    super.key,
    required this.widget,
    required bool isQuestion,
    required Future<void> Function() onReplay,
  }) : _isQuestion = isQuestion,
       _onReplay = onReplay;

  final VqaHistoryItemWidget widget;
  final bool _isQuestion;
  final Future<void> Function() _onReplay;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text(
        widget.item.title,
        style: const TextStyle(
          fontSize: kTitleFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isQuestion)
              SelectableText(
                widget.item.question!,
                style: const TextStyle(
                  fontSize: kContentFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            if (_isQuestion) const SizedBox(height: kSpacing),
            SelectableText(
              widget.item.text,
              style: const TextStyle(fontSize: kContentFontSize),
            ),
          ],
        ),
      ),
      actions: [
        Semantics(
          label: L10n.current.close,
          button: true,
          child: IconButton(
            tooltip: L10n.current.close,
            iconSize: kIconSize,
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
            },
            icon: Icon(Icons.close, semanticLabel: L10n.current.close),
          ),
        ),
        Semantics(
          label: L10n.current.replay,
          button: true,
          child: IconButton(
            tooltip: L10n.current.replay,
            iconSize: kIconSize,
            onPressed: () async {
              await _onReplay();
            },
            icon: Icon(Icons.replay, semanticLabel: L10n.current.replay),
          ),
        ),
      ],
    );
  }
}
