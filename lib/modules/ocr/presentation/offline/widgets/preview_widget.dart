import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';
import 'package:sight_mate/modules/shared/i18n/data/l10n/l10n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';

class PreviewWidget extends StatefulWidget {
  final ui.Image uiImage;
  final Uint8List imageBytes;

  const PreviewWidget({
    required this.uiImage,
    required this.imageBytes,
    super.key,
  });

  @override
  State<PreviewWidget> createState() => _PreviewWidgetState();
}

class _PreviewWidgetState extends State<PreviewWidget> {
  final GlobalKey _imageKey = GlobalKey();
  Offset? _start;
  Offset? _current;
  Uint8List? _croppedBytes;
  List<String> _lastDetectedTexts = [];
  final _ocrProvider = GetIt.I.get<OcrProvider>(instanceName: 'offline');
  final _ttsProvider = GetIt.I.get<TtsProvider>();
  final double _confidenceThreshold = 0.2;

  void _onPanStart(DragStartDetails details) {
    final box = _imageKey.currentContext!.findRenderObject() as RenderBox;
    final local = box.globalToLocal(details.globalPosition);
    setState(() {
      _start = local;
      _current = local;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final box = _imageKey.currentContext!.findRenderObject() as RenderBox;
    final local = box.globalToLocal(details.globalPosition);
    setState(() => _current = local);
  }

  Rect _mapToImageRect() {
    final box = _imageKey.currentContext!.findRenderObject() as RenderBox;
    final dispSize = box.size;
    final imgW = widget.uiImage.width.toDouble();
    final imgH = widget.uiImage.height.toDouble();
    final scale = min(dispSize.width / imgW, dispSize.height / imgH);
    final fittedW = imgW * scale;
    final fittedH = imgH * scale;
    final dx = (dispSize.width - fittedW) / 2;
    final dy = (dispSize.height - fittedH) / 2;

    final x1 = ((_start!.dx - dx) / scale).clamp(0.0, imgW);
    final y1 = ((_start!.dy - dy) / scale).clamp(0.0, imgH);
    final x2 = ((_current!.dx - dx) / scale).clamp(0.0, imgW);
    final y2 = ((_current!.dy - dy) / scale).clamp(0.0, imgH);

    return Rect.fromLTRB(min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2));
  }

  Future<void> _cropAndDetect() async {
    if (_start == null || _current == null) return;
    final rect = _mapToImageRect();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImageRect(
      widget.uiImage,
      rect,
      Rect.fromLTWH(0, 0, rect.width, rect.height),
      Paint(),
    );
    final picture = recorder.endRecording();
    if (rect.width == 0 || rect.height == 0) {
      await _speak([L10n.current.incorrectSelection]);
      return;
    }
    final croppedImg = await picture.toImage(
      rect.width.toInt(),
      rect.height.toInt(),
    );
    final byteData = await croppedImg.toByteData(
      format: ui.ImageByteFormat.png,
    );
    _croppedBytes = byteData!.buffer.asUint8List();
    List<OcrResult> recognized = [];
    try {
      recognized = await _ocrProvider.processImage(
        OcrInput(bytes: _croppedBytes as List<int>),
      );
    } catch (e) {
      await _speak([L10n.current.errorOccurred]);
      return;
    }
    _showResultDialog();

    _lastDetectedTexts =
        recognized
            .where(
              (l) =>
                  (l.confidence ?? 0) >= _confidenceThreshold &&
                  l.text.trim().isNotEmpty,
            )
            .map((l) => l.text.trim())
            .toList();

    if (_lastDetectedTexts.isEmpty) {
      await _speak([L10n.current.noTextDetected]);
    } else {
      await _speak(_lastDetectedTexts);
    }
  }

  Future<void> _speak(List<String> texts) async {
    if (texts.isEmpty) return;
    var textToSpeak = '';
    for (final t in texts) {
      textToSpeak += t;
      textToSpeak += '\n';
    }
    await _ttsProvider.speak(textToSpeak);
  }

  Future<void> onCloseDialog(BuildContext context) async {
    Navigator.of(context).pop();
    await _ttsProvider.stop();
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder:
          (_) => PopScope(
            onPopInvokedWithResult:
                (didPop, result) async => await _ttsProvider.stop(),
            child: AlertDialog(
              content:
                  _croppedBytes != null
                      ? Image.memory(_croppedBytes!)
                      : const SizedBox(),
              actions: [
                TextButton(
                  onPressed: () async => await onCloseDialog(context),
                  child: Text(L10n.current.close),
                ),
                if (_lastDetectedTexts.isNotEmpty)
                  TextButton(
                    onPressed: () async {
                      await _speak(_lastDetectedTexts);
                    },
                    child: Text(L10n.current.replay),
                  ),
              ],
            ),
          ),
    );
  }

  @override
  void dispose() {
    GetIt.I.resetLazySingleton(instance: _ocrProvider);
    GetIt.I.resetLazySingleton(instance: _ttsProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.current.preview)),
      body: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        child: Center(
          child: Container(
            key: _imageKey,
            color: Colors.black,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.memory(widget.imageBytes, fit: BoxFit.contain),
                ),
                if (_start != null && _current != null)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _SelectionPainter(_start!, _current!),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (_start != null && _current != null) ? _cropAndDetect : null,
        icon: const Icon(Icons.text_snippet),
        label: Text(L10n.current.read),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _SelectionPainter extends CustomPainter {
  final Offset start;
  final Offset end;

  const _SelectionPainter(this.start, this.end);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.yellow;
    canvas.drawRect(Rect.fromPoints(start, end), paint);
  }

  @override
  bool shouldRepaint(covariant _SelectionPainter old) {
    return old.start != start || old.end != end;
  }
}
