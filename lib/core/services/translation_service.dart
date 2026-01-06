import 'package:translator/translator.dart';
import '../constants/app_constants.dart';
import '../models/translation_model.dart';
import 'storage_service.dart';

class TranslationService {
  static TranslationService? _instance;
  final GoogleTranslator _translator = GoogleTranslator();
  late final StorageService _storageService;

  TranslationService._internal();

  static Future<TranslationService> getInstance() async {
    _instance ??= TranslationService._internal();
    _instance!._storageService = await StorageService.getInstance();
    return _instance!;
  }

  Future<String> translate(String text, String targetLanguageCode) async {
    if (targetLanguageCode == 'en' || text.isEmpty) {
      return text;
    }

    final cacheKey = _generateCacheKey(text, targetLanguageCode);
    final cachedTranslation = _storageService.getCachedTranslation(cacheKey, targetLanguageCode);
    
    if (cachedTranslation != null && !_storageService.isCacheExpired()) {
      return cachedTranslation.text;
    }

    try {
      final translation = await _translator.translate(
        text,
        from: 'en',
        to: targetLanguageCode,
      );

      final translationModel = TranslationModel(
        key: cacheKey,
        text: translation.text,
        languageCode: targetLanguageCode,
        lastUpdated: DateTime.now(),
      );

      await _storageService.cacheTranslation(translationModel);
      return translation.text;
    } catch (e) {
      return text;
    }
  }

  String _generateCacheKey(String text, String languageCode) {
    return '${text.hashCode}_$languageCode';
  }
}