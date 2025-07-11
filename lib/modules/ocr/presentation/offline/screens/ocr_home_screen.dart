import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';
import 'package:sight_mate/modules/ocr/presentation/ocr_presentation.dart';
import 'package:sight_mate/modules/shared/camera/camera_helper.dart';
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
  final _cameraHelper = CameraHelper();
  late Future<bool> _isCameraReady;

  // TTS
  final _ttsProvider = DI.get<TtsProvider>();

  // Live ocr
  final _liveOcrUsecase = LiveOcrUsecase();
  Timer? _frameTimer;
  bool _isProcessingFrame = false, _isLiveMode = true;

  // ocr mode repo
  final _ocrModeRepositroy = DI.get<OcrModeRepository>();

  // Capture mode
  bool _isCameraLoading = false;

  @override
  void initState() {
    super.initState();
    final mode = _ocrModeRepositroy.getMode();
    if (mode == 1) {
      setState(() {
        _isLiveMode = false;
      });
    }
    _isCameraReady = _cameraHelper.isCameraReady.then((value) {
      if (_isLiveMode) {
        _startPeriodicFrameCapture();
      }
      return value;
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
    final frameBytes = await _cameraHelper.getFrameBytes();
    if (frameBytes == null) return;
    final textToSpeak = await _liveOcrUsecase.processFrameBytes(frameBytes);
    if (_isLiveMode) {
      await _ttsProvider.speak(textToSpeak);
      await _ttsProvider.waitToEnd();
    }
  }

  Future<void> _captureFrame() async {
    if (_isLiveMode) {
      return;
    }
    if (_isCameraLoading) return;
    if (mounted) {
      setState(() {
        _isCameraLoading = true;
      });
    }

    final frameBytesAndImage = await _cameraHelper.getFrameBytesAndImage();
    if (frameBytesAndImage == null) {
      if (mounted) {
        setState(() {
          _isCameraLoading = false;
        });
      }
      return;
    }
    if (mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OcrCaptureScreen(
            uiImage: frameBytesAndImage.image,
            imageBytes: frameBytesAndImage.bytes as Uint8List,
          ),
        ),
      );
    }
    if (mounted) {
      setState(() {
        _isCameraLoading = false;
      });
    }
  }

  @override
  void dispose() {
    DI.resetLazySingleton<OcrProvider>(instanceName: OcrProviderModes.OFFLINE);
    _frameTimer?.cancel();
    _cameraHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _isCameraReady,
      builder: (context, snapshot) {
        final isReady = snapshot.connectionState == ConnectionState.done;

        return WidgetScaffold(
          title:
              '${L10n.current.textMode} - ${_isLiveMode ? L10n.current.liveMode : L10n.current.captureMode}',
          floatingActionButton: isReady
              ? FloatingActionButton.extended(
                  onPressed: () async {
                    if (mounted) {
                      setState(() {
                        _isLiveMode = !_isLiveMode;
                      });
                      _ocrModeRepositroy.updateMode(_isLiveMode ? 0 : 1);
                    }

                    if (_isLiveMode) {
                      _startPeriodicFrameCapture();
                      await _ttsProvider.stop();
                      await _ttsProvider.speak(
                        L10n.current.activated(L10n.current.liveMode),
                      );
                    } else {
                      _frameTimer?.cancel();
                      await _ttsProvider.stop();
                      await _ttsProvider.speak(
                        L10n.current.activated(L10n.current.captureMode),
                      );
                    }
                  },
                  icon: const Icon(Icons.cameraswitch, size: 28),
                  label: Text(
                    _isLiveMode
                        ? L10n.current.liveMode
                        : L10n.current.captureMode,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  tooltip: _isLiveMode
                      ? L10n.current.liveMode
                      : L10n.current.captureMode,
                  heroTag: _isLiveMode
                      ? L10n.current.liveMode
                      : L10n.current.captureMode,
                  elevation: 8.0,
                  isExtended: true,
                  extendedPadding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                )
              : null,
          body: isReady
              ? GestureDetector(
                  onTap: _captureFrame,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CameraPreview(_cameraHelper.controller),
                      if (_isCameraLoading)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black45,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
