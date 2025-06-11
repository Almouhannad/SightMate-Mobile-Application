import 'package:flutter_dotenv/flutter_dotenv.dart';

/// A static configuration class that reads environment values
/// from the loaded .env file
class Config {
  // If a key is missing, you can provide a default or throw an error.
  // Here, we throw an exception if a required key is missing to
  // catch mis confguration at startup

  static String get ocrServiceApiBaseUrl {
    final value = dotenv.env['OCR_SERVICE_API_BASE_URL'];
    if (value == null || value.isEmpty) {
      throw Exception('OCR_SERVICE_API_BASE_URL is not set in .env');
    }
    return value;
  }

  static String get vqaServiceApiBaseUrl {
    final value = dotenv.env['VQA_SERVICE_API_BASE_URL'];
    if (value == null || value.isEmpty) {
      throw Exception('VQA_SERVICE_API_BASE_URL is not set in .env');
    }
    return value;
  }
}
