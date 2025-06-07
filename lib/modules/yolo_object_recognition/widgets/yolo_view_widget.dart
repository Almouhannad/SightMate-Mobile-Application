import 'package:flutter/material.dart';
import 'package:sight_mate/modules/yolo_object_recognition/yolo_object_recognition.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class YoloViewWidget extends StatefulWidget {
  const YoloViewWidget({super.key});

  @override
  State<YoloViewWidget> createState() => _YoloViewWidgetState();
}

class _YoloViewWidgetState extends State<YoloViewWidget> {
  late Future<YOLOViewController> initilizeFeature;
  final YoloController _controller = YoloController();
  final YoloObjectRecognitionConfig _config = YoloObjectRecognitionConfig();

  @override
  void initState() {
    super.initState();
    initilizeFeature = _controller.controller;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initilizeFeature,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return YOLOView(
            modelPath: _config.modelPath,
            task: _config.task,
            controller: snapshot.data,
            cameraResolution: _config.cameraResolution,
            streamingConfig: _config.streamingConfig,
            onResult:
                (results) async => await _controller.processResults(results),
            showNativeUI: false,
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Center(child: CircularProgressIndicator())],
          );
        }
      },
    );
  }
}
