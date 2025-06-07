import 'package:flutter/material.dart';
import 'package:sight_mate/modules/shared/i18n/data/l10n/l10n.dart';
import 'package:sight_mate/modules/shared/widgets/shared_widgets.dart';
import 'package:sight_mate/modules/yolo_object_recognition/yolo_object_recognition.dart';

class ObjectRecognitionHomeScreen extends StatelessWidget {
  const ObjectRecognitionHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetScaffold(
      body: YoloViewWidget(),
      title: L10n.current.objectMode,
    );
  }
}
