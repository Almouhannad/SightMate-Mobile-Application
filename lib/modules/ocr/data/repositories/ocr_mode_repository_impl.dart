import 'package:shared_preferences/shared_preferences.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';

class OcrModeRepositoryImpl extends OcrModeRepository {
  final String _storageKey = 'ocr_mode';
  final SharedPreferences _sharedPreferences = DI.get<SharedPreferences>();

  @override
  int getMode() {
    final mode = _sharedPreferences.getInt(_storageKey);
    if (mode == null) {
      return 0; // Live is default
    }
    return mode;
  }

  @override
  Future<void> updateMode(int modeNumber) async {
    await _sharedPreferences.setInt(_storageKey, modeNumber);
  }
}
