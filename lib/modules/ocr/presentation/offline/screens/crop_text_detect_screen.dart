import 'dart:async';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sight_mate/modules/ocr/presentation/ocr_presentation.dart';
import 'package:sight_mate/modules/shared/i18n/data/l10n/l10n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';

class CropTextDetectScreen extends StatefulWidget {
  const CropTextDetectScreen({super.key});

  @override
  CropTextDetectScreenState createState() => CropTextDetectScreenState();
}

class CropTextDetectScreenState extends State<CropTextDetectScreen> {
  CameraController? _controller;
  Future<void>? _initFuture;
  final _ttsProvider = GetIt.I.get<TtsProvider>();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _setupCamera();
    _initializeTts();
  }

  Future<void> _setupCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );
    _initFuture = _controller!.initialize();
    setState(() {});
  }

  Future<void> _initializeTts() async {
    await _ttsProvider.speak(L10n.current.textMode);
  }

  Future<void> _captureFrame() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    try {
      try {
        await _controller?.setFlashMode(FlashMode.auto);
        await _controller?.setFocusMode(FocusMode.auto);
        await Future.delayed(const Duration(milliseconds: 200));
      } catch (_) {}

      final file = await _controller!.takePicture();
      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();

      if (mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => PreviewWidget(uiImage: frame.image, imageBytes: bytes),
          ),
        );
      }

      await _controller?.resumePreview();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        return GestureDetector(
          onTap: _captureFrame,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(_controller!),
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black45,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
