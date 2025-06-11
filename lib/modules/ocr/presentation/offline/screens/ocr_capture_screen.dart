import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:sight_mate/app/injection.dart';
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
  late final ImageRectangleMapper _rectangleMapper;
  Uint8List? _croppedBytes;
  String _lastDetectedTexts = '';
  bool _isProcessingImage = false;

  final captureOcrUsecase = CaptureOcrUsecase();
  final _ttsProvider = DI.get<TtsProvider>();

  @override
  void initState() {
    super.initState();
    _rectangleMapper = ImageRectangleMapper(
      imageKey: _imageKey,
      imageSize: Size(
        widget.uiImage.width.toDouble(),
        widget.uiImage.height.toDouble(),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    if (mounted) {
      setState(() {
        _rectangleMapper.onPanStart(details);
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (mounted) {
      setState(() {
        _rectangleMapper.onPanUpdate(details);
      });
    }
  }

  Future<void> _cropAndDetect() async {
    if (mounted) {
      setState(() {
        _isProcessingImage = true;
      });
    }
    if (_rectangleMapper.mapToImageRect() == null) return;

    final rect = _rectangleMapper.mapToImageRect()!;
    if (rect.width <= CaptureOcrUsecaseConfig.minWidth ||
        rect.height <= CaptureOcrUsecaseConfig.minHeight) {
      if (mounted) {
        setState(() => _isProcessingImage = false);
      }
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
      if (mounted) {
        setState(() {
          _lastDetectedTexts = value;
          _isProcessingImage = false;
        });
      }
    });

    _showResultDialog();
    await _ttsProvider.speak(_lastDetectedTexts);
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (_) => PopScope(
        onPopInvokedWithResult: (didPop, result) async =>
            await _ttsProvider.stop(),
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
                if (_rectangleMapper.mapToImageRect() != null)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: SelectionPainter(
                        _rectangleMapper.getScreenRect()!.topLeft,
                        _rectangleMapper.getScreenRect()!.bottomRight,
                      ),
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
        onPressed: _rectangleMapper.mapToImageRect() != null
            ? _cropAndDetect
            : null,
        icon: const Icon(Icons.text_snippet, size: 28),
        label: Text(
          L10n.current.read,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        tooltip: L10n.current.read,
        heroTag: L10n.current.read,
        elevation: 8.0,
        isExtended: true,
        extendedPadding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
