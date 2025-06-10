import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/shared/camera/camera_helper.dart';
import 'package:sight_mate/modules/shared/i18n/i18n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_provider.dart';
import 'package:sight_mate/modules/shared/widgets/widget_scaffold.dart';
import 'package:sight_mate/modules/vqa/presentation/vqa_presentation.dart';

class VqaHomeScreen extends StatefulWidget {
  const VqaHomeScreen({super.key});

  @override
  State<VqaHomeScreen> createState() => _VqaHomeScreenState();
}

class _VqaHomeScreenState extends State<VqaHomeScreen> {
  final _ttsProvider = DI.get<TtsProvider>();
  final CameraHelper _cameraHelper = CameraHelper();
  late Future<bool> _isCameraReady;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _isCameraReady = _cameraHelper.isCameraReady;
  }

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
      body: FutureBuilder(
        future: _isCameraReady,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return GestureDetector(
            onTap: _captureFrame,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_cameraHelper.controller),
                if (_isCapturing)
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
      title: L10n.current.imageMode,
    );
  }

  Future<void> _captureFrame() async {
    if (_isCapturing) {
      return;
    }
    setState(() {
      _isCapturing = true;
    });
    _ttsProvider.speak(L10n.current.pleaseWait);
    final frameBytesAndImage = await _cameraHelper.getFrameBytesAndImage().then(
      (value) {
        setState(() {
          _isCapturing = false;
        });
        return value;
      },
    );
    if (frameBytesAndImage == null) {
      return;
    }
    if (mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VqaPreviewScreen(
            image: frameBytesAndImage.image,
            imageBytes: frameBytesAndImage.bytes,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _cameraHelper.dispose();
    super.dispose();
  }
}
