import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class YoloObjectRecognitionConfig {
  final String modelPath = 'yolo11n';
  final double confidenceThreshold = .5;
  final double iouThreshold = .6; // Intersect over union
  final int numItemsThreshold = 5;
  final String cameraResolution = '720p';
  final YOLOStreamingConfig streamingConfig = YOLOStreamingConfig(
    includeDetections: true,
    includeClassifications: false,
    includeProcessingTimeMs: true,
    includeFps: true,
    includeMasks: false,
    includePoses: false,
    includeOBB: false,
    includeOriginalImage: false,

    throttleInterval: Duration(
      seconds: 5,
    ), // Give results to speak every <durataion>

    maxFPS: 20, // TODO Cahnge based on device performance
    inferenceFrequency: 10,
    skipFrames: 1,
    // 20 fps, 10 processed (processing every other frame)
  );
  final task = YOLOTask.detect;
  final repeatInterval = Duration(seconds: 5);
  final waitInterval = Duration(seconds: 2);
}
