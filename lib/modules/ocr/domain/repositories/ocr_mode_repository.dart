abstract class OcrModeRepository {
  Future<void> updateMode(int modeNumber); // 0 live, 1 capture
  int getMode();
}
