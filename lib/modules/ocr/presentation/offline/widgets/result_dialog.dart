import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';

class ResultDialog extends StatefulWidget {
  final Uint8List captureBytes;
  final String text;

  const ResultDialog({
    super.key,
    required this.captureBytes,
    required this.text,
  });

  @override
  State<ResultDialog> createState() => _ResultDialogState();
}

class _ResultDialogState extends State<ResultDialog> {
  String descriptionText = '';
  bool isDescribing = false;
  late Future<bool> isOnlineFuture;

  final _ttsProvider = DI.get<TtsProvider>();
  final _ocrConnectivityProvider = DI.get<OcrConnectivityProvider>();
  final describeOcrUsecase = DescribeOcrUsecase();

  @override
  void initState() {
    super.initState();
    isOnlineFuture = _ocrConnectivityProvider.isConnected();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      content: Image.memory(widget.captureBytes),
      actions: [
        // Close button
        Semantics(
          label: L10n.current.close,
          button: true,
          child: IconButton(
            tooltip: L10n.current.close,
            onPressed: () async => await onCloseDialog(context),
            icon: Icon(Icons.close, semanticLabel: L10n.current.close),
          ),
        ),

        if (widget.text != L10n.current.noTextDetected)
          // Describe button: only shows when isOnlineFuture is done and true
          FutureBuilder<bool>(
            future: isOnlineFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data == true) {
                // If we're in the middle of describing, show spinner
                if (isDescribing) {
                  return const SizedBox(
                    width: 48,
                    height: 48, // match IconButton size
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                // Otherwise show the normal Describe IconButton
                return Semantics(
                  label: L10n.current.describe,
                  button: true,
                  child: IconButton(
                    tooltip: L10n.current.describe,
                    onPressed: () async => onDescribe(),
                    icon: Icon(
                      Icons.info,
                      semanticLabel: L10n.current.describe,
                    ),
                  ),
                );
              }

              // Not online or still checking:
              return const SizedBox.shrink();
            },
          ),

        // Replay button
        if (widget.text != L10n.current.noTextDetected)
          Semantics(
            label: L10n.current.replay,
            button: true,
            child: IconButton(
              tooltip: L10n.current.replay,
              onPressed: () async {
                await _ttsProvider.speak(widget.text);
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

  Future<void> onDescribe() async {
    await _ttsProvider.stop();

    try {
      if (descriptionText.isEmpty) {
        setState(() => isDescribing = true);
        await _ttsProvider.speak(L10n.current.pleaseWait);
        descriptionText = await describeOcrUsecase.processCapture(
          widget.captureBytes,
        );
      }
      // After we have text, stop spinner and speak
      setState(() => isDescribing = false);
      await _ttsProvider.speak(descriptionText);
    } catch (e) {
      setState(() => isDescribing = false);
    }
  }
}
