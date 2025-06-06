import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sight_mate/app/config.dart';
import 'package:sight_mate/modules/ocr/domain/ocr_domain.dart';

class OcrProviderOnlineImpl extends OcrProvider {
  @override
  Future<OcrOutput> processImage(OcrInput input) async {
    // Build the URI
    final uri = Uri.parse('${Config.ocrServiceApiBaseUrl}/ocr/predict');
    // Construct the JSON body
    //    - "bytes": a List<int> (already in input.bytes)
    //    - "metadata": either the provided map or an empty map
    //    - "options": { "lang": { "lang": "<code>" } }
    final Map<String, dynamic> payload = {
      'bytes': input.bytes,
      'metadata': input.metadata ?? {},
      'options': {
        'lang': {'lang': input.options.lang.lang.toLowerCase()},
      },
    };

    // POST the request
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    // Handle non‐200 statuses
    if (response.statusCode != 200) {
      throw Exception(
        'OCR request failed with status ${response.statusCode}: ${response.body}',
      );
    }

    // Parse the JSON response
    final Map<String, dynamic> jsonResponse =
        json.decode(response.body) as Map<String, dynamic>;

    // Extract "texts" array
    final List<dynamic> textsJson = jsonResponse['texts'] ?? [];

    // Convert each entry into OcrResult
    final List<OcrResult> results =
        textsJson.map((entry) {
          final Map<String, dynamic> m = entry as Map<String, dynamic>;
          final String detectedText = m['text'] as String;
          final double? confidence =
              m['confidence'] != null
                  ? (m['confidence'] as num).toDouble()
                  : null;
          final Map<String, dynamic> box = m['box'] as Map<String, dynamic>;

          // The API gives left, top, right, bottom. We convert to Rect via fromLTRB.
          final double left = (box['left'] as num).toDouble();
          final double top = (box['top'] as num).toDouble();
          final double right = (box['right'] as num).toDouble();
          final double bottom = (box['bottom'] as num).toDouble();
          final Rect rect = Rect.fromLTRB(left, top, right, bottom);

          return OcrResult(
            text: detectedText,
            confidence: confidence,
            box: rect,
          );
        }).toList();

    // Grab optional "description" object from the response
    final Map<String, dynamic>? description =
        (jsonResponse['description'] as Map<String, dynamic>?);

    // Return an OcrOutput
    // debugPrint(description?['sentence']);
    return OcrOutput(texts: results, description: description);
  }

  @override
  void dispose() {
    // No resources to clean up in this implementation.
  }
}
