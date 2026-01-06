class AppConstants {
  // Supported Languages
  static const Map<String, String> supportedLanguages = {
    'English': 'en',
    'Hindi': 'hi',
    'Telugu': 'te',
    'Kannada': 'kn',
    'Sanskrit': 'sa',
    'Tamil': 'ta',
    'Malayalam': 'ml',
    'Marathi': 'mr',
  };

  // Storage Keys
  static const String selectedLanguageKey = 'selected_language';
  static const String translationCacheKey = 'translation_cache';
  static const String lastTranslationUpdateKey = 'last_translation_update';

  // Cache Settings
  static const Duration cacheExpiration = Duration(days: 7);
  static const int maxCacheSize = 1000; // Maximum number of cached translations

  // Default Language
  static const String defaultLanguage = 'en';
  static const String defaultLanguageName = 'English';

  // API Settings (for future dynamic content)
  static const String baseApiUrl = 'https://api.your-temple-app.com';
  static const Duration apiTimeout = Duration(seconds: 30);
}