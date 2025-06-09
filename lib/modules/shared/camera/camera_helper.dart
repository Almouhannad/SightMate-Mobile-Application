import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraHelper {
  late CameraController? _controller;
  bool _isInitialized = false;
  bool _isCapturingFrame = false;
  final CameraException _notInitilizedException = CameraException(
    "CAMERA_NOT_READY",
    "Camera controller is not initilized yet",
  );

  Future<bool> _initilize() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.max,
      enableAudio: false,
    );
    try {
      await Future.delayed(Duration(milliseconds: 1000));
      await _controller!.initialize();
      // Warm-up the camera by taking a dummy picture and discarding it
      // This will make feature page loading slower, but first call for the feature will be much faster
      final file = await _controller!.takePicture();
      await file.readAsBytes(); // Trigger JPEG decoding

      _isInitialized = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> get isCameraReady => _initilize();

  CameraController get controller {
    if (!_isInitialized) {
      throw _notInitilizedException;
    }
    return _controller!;
  }

  // Don't reuse this in next one to make sure that `_isCapturingFrame` is set correctly
  Future<List<int>?> getFrameBytes() {
    if (!_isInitialized) {
      return Future.error(_notInitilizedException);
    }
    if (_isCapturingFrame) {
      return Future.value(null);
    }

    _isCapturingFrame = true;

    return _controller!
        .takePicture()
        .then((frame) => frame.readAsBytes())
        .whenComplete(() => _isCapturingFrame = false);
  }

  Future<({List<int> bytes, ui.Image image})?> getFrameBytesAndImage() {
    if (!_isInitialized) {
      return Future.error(_notInitilizedException);
    }
    if (_isCapturingFrame) {
      return Future.value(null);
    }

    _isCapturingFrame = true;

    return _controller!
        .takePicture()
        .then((file) => file.readAsBytes())
        .then((bytes) {
          return ui
              .instantiateImageCodec(bytes)
              .then(
                (codec) => codec.getNextFrame().then(
                  (frame) => (bytes: bytes, image: frame.image),
                ),
              );
        })
        .whenComplete(() => _isCapturingFrame = false);
  }

  Future<void> dispose() async {
    _isInitialized = false;
    if (_controller != null) {
      await _controller!.dispose();
    }
    _controller = null;
  }
}
