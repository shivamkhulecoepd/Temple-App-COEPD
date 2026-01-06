import 'package:equatable/equatable.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

class LoadLanguageEvent extends LanguageEvent {}

class ChangeLanguageEvent extends LanguageEvent {
  final String languageCode;
  final String languageName;

  const ChangeLanguageEvent({
    required this.languageCode,
    required this.languageName,
  });

  @override
  List<Object?> get props => [languageCode, languageName];
}

class ClearTranslationCacheEvent extends LanguageEvent {}