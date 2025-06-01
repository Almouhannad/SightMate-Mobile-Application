class OcrLang {
  final String lang;
  OcrLang({required this.lang});
}

class OCRLangs {
  static final OcrLang _en = OcrLang(lang: 'en');
  static OcrLang get EN => _en;

  static final OcrLang _ar = OcrLang(lang: 'ar');
  static OcrLang get AR => _ar;

  static final List<String> _supportedLangs = ['en', 'ar'];
  static List<String> get LANGS => _supportedLangs;
}
