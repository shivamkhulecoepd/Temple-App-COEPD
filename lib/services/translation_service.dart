import 'package:translator/translator.dart';
import 'package:flutter/foundation.dart';

class TranslationService {
  final GoogleTranslator _translator = GoogleTranslator();

  // Cache for in-memory access during the session
  final Map<String, Map<String, String>> _cache = {};

  Future<String> translate(String text, String targetLanguage) async {
    if (targetLanguage == 'en') return text; // Default language

    // Check in-memory cache first
    if (_cache[targetLanguage] != null &&
        _cache[targetLanguage]!.containsKey(text)) {
      return _cache[targetLanguage]![text]!;
    }

    try {
      final translation = await _translator.translate(text, to: targetLanguage);

      // Update cache
      if (!_cache.containsKey(targetLanguage)) {
        _cache[targetLanguage] = {};
      }
      _cache[targetLanguage]![text] = translation.text;

      return translation.text;
    } catch (e) {
      debugPrint('Translation Error: $e');
      return text; // Return original text on failure
    }
  }

  // Define language codes mapping
  static String getLanguageCode(String languageName) {
    switch (languageName.toLowerCase()) {
      case 'hindi':
        return 'hi';
      case 'telugu':
        return 'te';
      case 'kannada':
        return 'kn';
      case 'tamil':
        return 'ta';
      case 'malayalam':
        return 'ml';
      case 'marathi':
        return 'mr';
      case 'english':
      default:
        return 'en';
    }
  }
}
