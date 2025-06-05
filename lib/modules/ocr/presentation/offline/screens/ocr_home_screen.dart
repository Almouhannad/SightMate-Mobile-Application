import 'dart:async';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';
import 'package:sight_mate/modules/ocr/domain/usecases/live_ocr_usecase.dart';
import 'package:sight_mate/modules/ocr/presentation/ocr_presentation.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_domain.dart';
import 'package:sight_mate/modules/shared/widgets/shared_widgets.dart';

class OcrHomeScreen extends StatefulWidget {
  const OcrHomeScreen({super.key});

  @override
  OcrHomeScreenState createState() => OcrHomeScreenState();
}

class OcrHomeScreenState extends State<OcrHomeScreen> {
  // Camera
  CameraController? _controller;
  Future<void>? _isCameraInitialized;

  // TTS
  final _ttsProvider = GetIt.I.get<TtsProvider>();

  // Live ocr
  final _liveOcrUsecase = LiveOcrUsecase();
  Timer? _frameTimer;
  bool _isProcessingFrame = false, _isLiveMode = true;

  // Capture mode
  bool _isCameraLoading = false;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );

    setState(() {
      // Initialize the controller
      _isCameraInitialized = _controller!.initialize().then((_) {
        _startPeriodicFrameCapture();
      });
    });
  }

  void _startPeriodicFrameCapture() {
    _frameTimer = Timer.periodic(_liveOcrUsecase.frameInterval, (_) async {
      if (_isProcessingFrame) return;
      _isProcessingFrame = true;
      await _processLiveFrame().then((_) {
        _isProcessingFrame = false;
      });
    });
  }

  Future<void> _processLiveFrame() async {
    // If camera isn't ready
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }
    final frame = await _controller!.takePicture();
    final bytes = await frame.readAsBytes();
    final textToSpeak = await _liveOcrUsecase.processFrameBytes(bytes);
    await _ttsProvider.speak(textToSpeak);
    await _ttsProvider.waitToEnd();
  }

  Future<void> _captureFrame() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isLiveMode) {
      return;
    }
    if (_isCameraLoading) return;
    setState(() {
      _isCameraLoading = true;
    });

    late XFile? file;
    // To handle capturing issues
    try {
      file = await _controller!.takePicture();
    } catch (_) {
      _captureFrame();
      return; // BTW: I'm stupidly genius
    }

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

    setState(() {
      _isCameraLoading = false;
    });
  }

  @override
  void dispose() {
    getIt.resetLazySingleton<OcrProvider>(instanceName: 'offline');
    _frameTimer?.cancel();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
      title: L10n.current.textMode,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            _isLiveMode = !_isLiveMode;
          });

          if (_isLiveMode) {
            _startPeriodicFrameCapture();
            await _ttsProvider.stop();
            await _ttsProvider.speak(
              L10n.current.activated(L10n.current.liveMode),
            );
          } else {
            _frameTimer!.cancel();
            await _ttsProvider.stop();
            await _ttsProvider.speak(
              L10n.current.activated(L10n.current.captureMode),
            );
          }
        },
        child: Icon(_isLiveMode ? Icons.pause : Icons.play_arrow),
      ),
      body: FutureBuilder<void>(
        future: _isCameraInitialized,
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
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _isLiveMode
                          ? L10n.current.liveMode
                          : L10n.current.captureMode,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                if (_isCameraLoading)
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
      ),
    );
  }
}
