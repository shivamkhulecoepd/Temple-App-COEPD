import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for SharedPreferences
class StorageKeys {
  static const String selectedLanguage = 'selected_language';
  static const String cachedTranslations = 'cached_translations';
  static const String firstLaunch = 'first_launch';
  static const String userLoggedIn = 'user_logged_in';
  static const String userData = 'user_data';
  static const String userToken = 'user_token';
}

class StorageService {
  static const String _keySelectedLanguage = StorageKeys.selectedLanguage;
  static const String _keyTranslations = StorageKeys.cachedTranslations;
  static const String _keyFirstLaunch = StorageKeys.firstLaunch;
  static const String _keyUserLoggedIn = StorageKeys.userLoggedIn;
  static const String _keyUserData = StorageKeys.userData;
  static const String _keyUserToken = StorageKeys.userToken;

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

  Future<void> setFirstLaunch(bool firstLaunch) async {
    final prefs = await getPreferences();
    await prefs.setBool(_keyFirstLaunch, firstLaunch);
  }

  Future<bool> isFirstLaunch() async {
    final prefs = await getPreferences();
    return prefs.getBool(_keyFirstLaunch) ?? true;
  }

  // ================= USER AUTHENTICATION METHODS =================

  /// Save user login status
  Future<void> setUserLoggedIn(bool isLoggedIn) async {
    final prefs = await getPreferences();
    await prefs.setBool(_keyUserLoggedIn, isLoggedIn);
  }

  /// Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    final prefs = await getPreferences();
    return prefs.getBool(_keyUserLoggedIn) ?? false;
  }

  /// Save user data as JSON string
  Future<void> saveUserData(String userDataJson) async {
    final prefs = await getPreferences();
    await prefs.setString(_keyUserData, userDataJson);
  }

  /// Get user data as JSON string
  Future<String?> getUserData() async {
    final prefs = await getPreferences();
    return prefs.getString(_keyUserData);
  }

  /// Save user token
  Future<void> saveUserToken(String token) async {
    final prefs = await getPreferences();
    await prefs.setString(_keyUserToken, token);
  }

  /// Get user token
  Future<String?> getUserToken() async {
    final prefs = await getPreferences();
    return prefs.getString(_keyUserToken);
  }

  /// Clear all user data (logout)
  Future<void> clearUserData() async {
    final prefs = await getPreferences();
    await prefs.remove(_keyUserLoggedIn);
    await prefs.remove(_keyUserData);
    await prefs.remove(_keyUserToken);
  }

  /// Clear all app data
  Future<void> clearAllData() async {
    final prefs = await getPreferences();
    await prefs.clear();
  }
}
