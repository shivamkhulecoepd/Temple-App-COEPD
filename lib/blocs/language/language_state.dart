part of 'language_bloc.dart';

class LanguageState extends Equatable {
  final String selectedLanguageCode;
  final String selectedLanguageName;
  final Map<String, String> translations; // Cache for current language
  final bool isLoading;

  const LanguageState({
    required this.selectedLanguageCode,
    required this.selectedLanguageName,
    this.translations = const {},
    this.isLoading = false,
  });

  factory LanguageState.initial() {
    return const LanguageState(
      selectedLanguageCode: 'en',
      selectedLanguageName: 'English',
    );
  }

  LanguageState copyWith({
    String? selectedLanguageCode,
    String? selectedLanguageName,
    Map<String, String>? translations,
    bool? isLoading,
  }) {
    return LanguageState(
      selectedLanguageCode: selectedLanguageCode ?? this.selectedLanguageCode,
      selectedLanguageName: selectedLanguageName ?? this.selectedLanguageName,
      translations: translations ?? this.translations,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [
    selectedLanguageCode,
    selectedLanguageName,
    translations,
    isLoading,
  ];
}
