import 'dart:developer';

import 'package:translator/translator.dart';

/// A service class to handle text translations with caching
/// This service handles dynamic translations from API/database content
/// without relying on static JSON files

class TranslationLanguageService {
  final GoogleTranslator _translator = GoogleTranslator();
  
  // Simple in-memory cache to store translations
  final Map<String, Map<String, String>> _translationCache = {};
  
  /// Translates a single text string to the target language
  Future<String> translateText(String text, String targetLanguage) async {
    if (text.isEmpty) return text;
    
    // Check if translation exists in cache
    final cacheKey = _getCacheKey(text, targetLanguage);
    if (_translationCache.containsKey(targetLanguage) && 
        _translationCache[targetLanguage]!.containsKey(cacheKey)) {
      return _translationCache[targetLanguage]![cacheKey]!;
    }
    
    try {
      var translation = await _translator.translate(
        text,
        to: targetLanguage,
      );
      
      // Cache the translation
      _cacheTranslation(text, targetLanguage, translation.text);
      
      return translation.text;
    } catch (e) {
      // Return original text if translation fails
      log('Translation error: $e');
      return text;
    }
  }
  
  /// Translates multiple text strings to the target language
  Future<Map<String, String>> translateMultipleTexts(
    List<String> texts, 
    String targetLanguage
  ) async {
    final Map<String, String> results = {};
    
    for (String text in texts) {
      final translated = await translateText(text, targetLanguage);
      results[text] = translated;
    }
    
    return results;
  }
  
  /// Translates dynamic content (like data from API/database)
  Future<String> translateDynamicContent(String content, String targetLanguage) async {
    // For dynamic content, we can apply translation
    return await translateText(content, targetLanguage);
  }
  
  /// Internal method to cache translations
  void _cacheTranslation(String original, String targetLanguage, String translated) {
    if (!_translationCache.containsKey(targetLanguage)) {
      _translationCache[targetLanguage] = {};
    }
    final cacheKey = _getCacheKey(original, targetLanguage);
    _translationCache[targetLanguage]![cacheKey] = translated;
  }
  
  /// Generates a cache key for a text and language combination
  String _getCacheKey(String text, String language) {
    return '\$text|\$language';
  }
  
  /// Clears the translation cache
  void clearCache() {
    _translationCache.clear();
  }
  
  /// Gets the size of the cache
  int getCacheSize() {
    int size = 0;
    for (var languageCache in _translationCache.values) {
      size += languageCache.length;
    }
    return size;
  }
  
  /// Checks if a translation is cached
  bool isCached(String text, String targetLanguage) {
    final cacheKey = _getCacheKey(text, targetLanguage);
    return _translationCache.containsKey(targetLanguage) && 
           _translationCache[targetLanguage]!.containsKey(cacheKey);
  }
}
