import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keySelectedLanguage = 'selected_language';
  static const String _keyTranslations = 'cached_translations';

  Future<SharedPreferences> getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> saveLanguage(String languageCode) async {
    final prefs = await getPreferences();
    await prefs.setString(_keySelectedLanguage, languageCode);
  }

  Future<String?> getLanguage() async {
    final prefs = await getPreferences();
    return prefs.getString(_keySelectedLanguage);
  }

  // Save translations map: {'hi': {'Hello': 'Namaste', ...}, ...}
  Future<void> saveTranslations(
    Map<String, Map<String, String>> translations,
  ) async {
    final prefs = await getPreferences();
    await prefs.setString(_keyTranslations, jsonEncode(translations));
  }

  Future<Map<String, Map<String, String>>> getTranslations() async {
    final prefs = await getPreferences();
    final String? jsonString = prefs.getString(_keyTranslations);

    if (jsonString != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(jsonString);
        // Convert dynamic map to typed map
        final Map<String, Map<String, String>> result = {};
        decoded.forEach((lang, texts) {
          result[lang] = Map<String, String>.from(texts);
        });
        return result;
      } catch (e) {
        return {};
      }
    }
    return {};
  }
}
