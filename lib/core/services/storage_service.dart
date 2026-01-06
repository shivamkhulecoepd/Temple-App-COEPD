import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/translation_model.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _preferences;

  StorageService._internal();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._internal();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Language Preferences
  Future<void> saveSelectedLanguage(String languageCode) async {
    await _preferences!.setString(AppConstants.selectedLanguageKey, languageCode);
  }

  String getSelectedLanguage() {
    return _preferences!.getString(AppConstants.selectedLanguageKey) ?? 
           AppConstants.defaultLanguage;
  }
}
  // Translation Cache Management
  Future<void> cacheTranslation(TranslationModel translation) async {
    final cacheKey = '${AppConstants.translationCacheKey}_${translation.languageCode}';
    final existingCache = _preferences!.getString(cacheKey);
    
    Map<String, dynamic> cache = {};
    if (existingCache != null) {
      cache = json.decode(existingCache);
    }
    
    cache[translation.key] = translation.toJson();
    
    // Limit cache size
    if (cache.length > AppConstants.maxCacheSize) {
      final sortedEntries = cache.entries.toList()
        ..sort((a, b) => DateTime.parse(b.value['lastUpdated'])
            .compareTo(DateTime.parse(a.value['lastUpdated'])));
      
      cache = Map.fromEntries(sortedEntries.take(AppConstants.maxCacheSize));
    }
    
    await _pref
  // Translation Cache Management
  Future<void> cacheTranslation(TranslationModel translation) async {
    final cacheKey = '${AppConstants.translationCacheKey}_${translation.languageCode}';
    final existingCache = _preferences!.getString(cacheKey);
    
    Map<String, dynamic> cache = {};
    if (existingCache != null) {
      cache = json.decode(existingCache);
    }
    
    cache[translation.key] = translation.toJson();
    await _preferences!.setString(cacheKey, json.encode(cache));
  }

  TranslationModel? getCachedTranslation(String key, String languageCode) {
    final cacheKey = '${AppConstants.translationCacheKey}_$languageCode';
    final cachedData = _preferences!.getString(cacheKey);
    
    if (cachedData != null) {
      final cache = json.decode(cachedData) as Map<String, dynamic>;
      if (cache.containsKey(key)) {
        return TranslationModel.fromJson(cache[key]);
      }
    }
    return null;
  }

  Future<void> clearTranslationCache([String? languageCode]) async {
    if (languageCode != null) {
      final cacheKey = '${AppConstants.translationCacheKey}_$languageCode';
      await _preferences!.remove(cacheKey);
    } else {
      final keys = _preferences!.getKeys()
          .where((key) => key.startsWith(AppConstants.translationCacheKey))
          .toList();
      for (final key in keys) {
        await _preferences!.remove(key);
      }
    }
  }

  // Cache expiration check
  bool isCacheExpired() {
    final lastUpdate = _preferences!.getString(AppConstants.lastTranslationUpdateKey);
    if (lastUpdate == null) return true;
    
    final lastUpdateTime = DateTime.parse(lastUpdate);
    return DateTime.now().difference(lastUpdateTime) > AppConstants.cacheExpiration;
  }

  Future<void> updateCacheTimestamp() async {
    await _preferences!.setString(
      AppConstants.lastTranslationUpdateKey,
      DateTime.now().toIso8601String(),
    );
  }
}