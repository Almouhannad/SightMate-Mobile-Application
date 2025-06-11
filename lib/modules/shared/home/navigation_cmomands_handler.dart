//NOTE: COUPLED Shared module
import 'package:sight_mate/core/page_route_settings.dart';
import 'package:sight_mate/modules/ocr/presentation/ocr_presentation.dart';
import 'package:sight_mate/modules/shared/string_utils/string_utils.dart';
import 'package:sight_mate/modules/vqa/presentation/vqa_presentation.dart';
import 'package:sight_mate/modules/yolo_object_recognition/yolo_object_recognition.dart';

const int kDistanceThreshold = 3;

class NavigationCommandsHandler {
  final List<PageRouteSettings> _modesRoutesSettings = [
    OcrHomeScreenRoute(),
    ObjectRecognitionHomeScreenRoute(),
    VqaHomeScreenRoute(),
  ];

  PageRouteSettings? handleCommand(String mode) {
    List<String> modesNames = _modesRoutesSettings.map((e) => e.name).toList();

    // Calculate distances
    List<int> distances = modesNames
        .map(
          (e) => StringUtils.levenshteinDistance(mode, e, caseSensitive: false),
        )
        .toList();

    // Find the index of the smallest distance
    int minIndex = 0;
    int minDistance = distances[0];
    for (int i = 1; i < distances.length; i++) {
      if (distances[i] < minDistance) {
        minDistance = distances[i];
        minIndex = i;
      }
    }
    if (minDistance <= kDistanceThreshold) {
      return _modesRoutesSettings[minIndex];
    }
    return null;
  }
}
