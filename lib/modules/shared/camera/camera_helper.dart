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

  Future<XFile?> getFrame() async {
    if (!_isInitialized) {
      throw _notInitilizedException;
    }
    if (_isCapturingFrame) {
      return null;
    }
    _isCapturingFrame = true;
    final frame = await _controller!.takePicture().then((value) {
      _isCapturingFrame = false;
      return value;
    });
    return frame;
  }

  Future<void> dispose() async {
    _isInitialized = false;
    if (_controller != null) {
      await _controller!.dispose();
    }
    _controller = null;
  }
}
