import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraHelper extends ChangeNotifier {
  CameraController? _controller;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  CameraController? get controller => _controller;

  Future<void> setupCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _isInitialized = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<XFile?> captureFrame() async {
    if (_controller == null || !_isInitialized) {
      return null;
    }

    try {
      return await _controller!.takePicture();
    } catch (_) {
      // Retry on failure
      return captureFrame();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    _isInitialized = false;
    super.dispose();
  }
}
