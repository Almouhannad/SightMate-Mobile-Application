import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';

class ResultDialog extends StatelessWidget {
  final Uint8List captureBytes;
  final String text;
  final _ttsProvider = DI.get<TtsProvider>();

  ResultDialog({super.key, required this.captureBytes, required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      content: Image.memory(captureBytes),
      actions: [
        Semantics(
          label: L10n.current.close,
          button: true,
          child: IconButton(
            tooltip: L10n.current.close,
            onPressed: () async => await onCloseDialog(context),
            icon: Icon(Icons.close, semanticLabel: L10n.current.close),
          ),
        ),
        if (text.isNotEmpty)
          Semantics(
            label: L10n.current.replay,
            button: true,
            child: IconButton(
              tooltip: L10n.current.replay,
              onPressed: () async {
                await _ttsProvider.speak(text);
              },
              icon: Icon(Icons.replay, semanticLabel: L10n.current.replay),
            ),
          ),
      ],
    );
  }

  Future<void> onCloseDialog(BuildContext context) async {
    Navigator.of(context).pop();
    await _ttsProvider.stop();
  }
}
