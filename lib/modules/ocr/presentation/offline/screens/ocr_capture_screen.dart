import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sight_mate/modules/ocr/domain/usecases/capture_ocr_usecase.dart';
import 'package:sight_mate/modules/ocr/presentation/ocr_presentation.dart';
import 'package:sight_mate/modules/shared/i18n/data/l10n/l10n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';
import 'package:sight_mate/modules/shared/widgets/shared_widgets.dart';

class OcrCaptureScreen extends StatefulWidget {
  final ui.Image uiImage;
  final Uint8List imageBytes;

  const OcrCaptureScreen({
    required this.uiImage,
    required this.imageBytes,
    super.key,
  });

  @override
  State<OcrCaptureScreen> createState() => _OcrCaptureScreenState();
}

class _OcrCaptureScreenState extends State<OcrCaptureScreen> {
  final GlobalKey _imageKey = GlobalKey();
  Offset? _start;
  Offset? _current;
  Uint8List? _croppedBytes;
  String _lastDetectedTexts = '';
  bool _isProcessingImage = false;

  final captureOcrUsecase = CaptureOcrUsecase();
  final _ttsProvider = GetIt.I.get<TtsProvider>();

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

  /// Map the user drag rectangle (in widget coordinates) into the underlying
  /// image's pixel coordinates ((accounting for a BoxFit.cover transform))
  Rect _mapToImageRect() {
    final box = _imageKey.currentContext!.findRenderObject() as RenderBox;
    final dispSize = box.size;
    final imgW = widget.uiImage.width.toDouble();
    final imgH = widget.uiImage.height.toDouble();

    // Because the Image is drawn with BoxFit.cover =>
    //   scale = max(dispW / imgW, dispH / imgH)
    final scale = max(dispSize.width / imgW, dispSize.height / imgH);
    final fittedW = imgW * scale;
    final fittedH = imgH * scale;

    final dx = (dispSize.width - fittedW) / 2;
    final dy = (dispSize.height - fittedH) / 2;

    // Convert both the start and current drag points into image-space
    final x1 = ((_start!.dx - dx) / scale).clamp(0.0, imgW);
    final y1 = ((_start!.dy - dy) / scale).clamp(0.0, imgH);
    final x2 = ((_current!.dx - dx) / scale).clamp(0.0, imgW);
    final y2 = ((_current!.dy - dy) / scale).clamp(0.0, imgH);

    return Rect.fromLTRB(min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2));
  }

  Future<void> _cropAndDetect() async {
    setState(() {
      _isProcessingImage = true;
    });
    if (_start == null || _current == null) return;

    final rect = _mapToImageRect();
    if (rect.width <= CaptureOcrUsecaseConfig.minWidth ||
        rect.height <= CaptureOcrUsecaseConfig.minHeight) {
      setState(() => _isProcessingImage = false);
      await _ttsProvider.speak(L10n.current.incorrectSelection);
      return;
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImageRect(
      widget.uiImage,
      rect,
      Rect.fromLTWH(0, 0, rect.width, rect.height),
      Paint(),
    );
    final picture = recorder.endRecording();

    final croppedImg = await picture.toImage(
      rect.width.toInt(),
      rect.height.toInt(),
    );
    final byteData = await croppedImg.toByteData(
      format: ui.ImageByteFormat.png,
    );
    _croppedBytes = byteData!.buffer.asUint8List();

    await captureOcrUsecase.processCapture(_croppedBytes!).then((value) {
      setState(() {
        _lastDetectedTexts = value;
        _isProcessingImage = false;
      });
    });

    _showResultDialog();
    await _ttsProvider.speak(_lastDetectedTexts);
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder:
          (_) => PopScope(
            onPopInvokedWithResult:
                (didPop, result) async => await _ttsProvider.stop(),
            child: ResultDialog(
              captureBytes: _croppedBytes!,
              text: _lastDetectedTexts,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
      title: L10n.current.preview,
      withDrawer: false,
      body: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        child: Center(
          child: Container(
            key: _imageKey,
            color: Colors.black,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Image.memory(widget.imageBytes, fit: BoxFit.cover),
                ),
                if (_start != null && _current != null)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: SelectionPainter(_start!, _current!),
                    ),
                  ),
                if (_isProcessingImage)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black45,
                      child: const Center(child: CircularProgressIndicator()),
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
