import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:temple_app/services/storage_service.dart';
import 'package:temple_app/services/translation_service.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final TranslationService _translationService;
  final StorageService _storageService;

  // In-memory cache of all loaded translations: { 'hi': {'Hello': 'Namaste'} }
  Map<String, Map<String, String>> _allTranslations = {};

  LanguageBloc({
    required TranslationService translationService,
    required StorageService storageService,
  }) : _translationService = translationService,
       _storageService = storageService,
       super(LanguageState.initial()) {
    on<LoadLanguage>(_onLoadLanguage);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onLoadLanguage(
    LoadLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    // Load persisted language
    final savedLangCode = await _storageService.getLanguage();

    // Load cached translations
    _allTranslations = await _storageService.getTranslations();

    if (savedLangCode != null) {
      // Find name from code (reverse lookup or store name too. For now simple mapping)
      // Assuming we mostly care about code.
      // Ideally we'd store name too or have a lookup map.
      // For simplicity, we just set code. The name is less critical for logic.

      final currentTranslations = _allTranslations[savedLangCode] ?? {};

      emit(
        state.copyWith(
          selectedLanguageCode: savedLangCode,
          selectedLanguageName: TranslationService.getLanguageName(
            savedLangCode,
          ),
          translations: currentTranslations,
          isLoading: false,
        ),
      );
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    final languageName = event.languageName;
    final languageCode = TranslationService.getLanguageCode(languageName);

    if (languageCode == state.selectedLanguageCode) return;

    // Switch to cached translations for this language
    final currentTranslations = _allTranslations[languageCode] ?? {};

    emit(
      state.copyWith(
        selectedLanguageCode: languageCode,
        selectedLanguageName: languageName,
        translations: currentTranslations,
      ),
    );

    // Fire and forget storage save to prevent UI blocking on rapid changes
    unawaited(_storageService.saveLanguage(languageCode));
  }

  // Method to be called by UI widgets to get translation
  Future<String> getTranslation(String text) async {
    final targetLang = state.selectedLanguageCode;
    if (targetLang == 'en') return text;

    // Check state cache first (which comes from memory/disk)
    if (state.translations.containsKey(text)) {
      return state.translations[text]!;
    }

    // Not in cache, fetch from API
    final translated = await _translationService.translate(text, targetLang);

    // Update local cache
    if (!_allTranslations.containsKey(targetLang)) {
      _allTranslations[targetLang] = {};
    }
    _allTranslations[targetLang]![text] = translated;

    // Persist to disk
    unawaited(_storageService.saveTranslations(_allTranslations));

    // Update state to trigger UI refresh if they are listening to specific keys
    // Note: Creating a new map to ensure state change
    final newTranslations = Map<String, String>.from(state.translations);
    newTranslations[text] = translated;

    // This is a bit of a side-effect update.
    // Ideally we would emit an event, but since this is a synchronous-like helper call,
    // we might accept a slight delay or rely on the helper returning the value.
    // However, to ensure consistency across the app for the same string, we should emit.
    // We cannot emit from here easily without an event.
    // So we rely on the return value for the caller, and next time it loads it will be there.
    // To make it reactive, the widget should probably listen to the stream or future.

    return translated;
  }
}
