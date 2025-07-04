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

  static String get backendApiBaseUri {
    final value = dotenv.env['BACKEND_BASE_URI'];
    if (value == null || value.isEmpty) {
      throw Exception('BACKEND_BASE_URI is not set in .env');
    }
    return value;
  }

  static String get identityApi => '/identity-api';
  static String get ocrApi => '/ocr-api';
  static String get vqaApi => '/vqa-api';
  static String get serverErrorDetailPropertyName => 'detail';
  static String get serverValidationErrorsPropertyName => 'errors';
  static String get serverValidationErrorDescriptionPropertyName =>
      'description';
  static String get clientValidationErrorsPropertyName => 'validation_errors';
}
