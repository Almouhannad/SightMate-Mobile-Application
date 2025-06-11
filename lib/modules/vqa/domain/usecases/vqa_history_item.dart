import 'package:sight_mate/modules/shared/i18n/i18n.dart';

class VqaHistoryItem {
  final String title;
  final String text;
  final String? question;

  String get textToSpeak {
    String ret = '';

    if (question != null) {
      ret += "${L10n.current.question}: $question\n";
      ret += "${L10n.current.answer}: $text";
    } else {
      ret += "${L10n.current.imageCaption}\n";
      ret += text;
    }
    return ret;
  }

  VqaHistoryItem({required this.title, required this.text, this.question});
}
